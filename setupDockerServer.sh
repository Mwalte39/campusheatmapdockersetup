#!/bin/bash
echo 'Beginning Server Setup'
mkdir campusHeatMapServices
cd campusHeatMapServices
echo 'Pulling and Running INFLUXDB'
docker run -d \
  --name influxdb \
  -p 8083:8083 -p 8086:8086 \
  -v $PWD/influxdb:/var/lib/influxdb \
  -e INFLUXDB_ADMIN_USER='admin' \
  -e INFLUXDB_ADMIN_PASSWORD='admin' \
  -e INFLUXDB_HTTP_AUTH_ENABLED='true' \
  influxdb:latest
echo 'Influx Starting'
sleep 30s
echo 'Influx Started'
echo 'Pulling and Running GRAFANA'
docker run -d \
  --name grafana \
  -p 3000:3000 \
  -v $PWD/grafana:/var/lib/grafana \
  --link influxdb \
  grafana/grafana:3.1.1
echo 'Grafana Starting'
sleep 30s
echo 'Grafana Started'
echo 'Adding Admin for Influx'
docker restart influxdb
echo 'influxdb created with username and password admin CHANGE THIS ASAP'
echo 'Pulling and Running COUCHBASEDB'
docker run -d \
  --name couchbasedb \
  -p 8091-8094:8091-8094 \
  -p 11210:11210 \
  -v $PWD/couchbase:/opt/couchbase/var\
  couchbase
echo 'COUCHBASEDB Starting'
sleep 30s


varip="$(ip route get 1 | awk '{print $NF;exit}')"

echo $varip

curl -u Administrator:password -v -X POST \
http://varip:8091/node/controller/setupServices \
-d 'services=kv%2Cn1ql%2Cindex'

curl -v -X POST \
http://$varip:8091/nodes/self/controller/settings \
-d 'path=%2Fopt%2Fcouchbase%2Fvar%2Flib%2Fcouchbase%2Fdata&index_path= \
%2Fopt%2Fcouchbase%2Fvar%2Flib%2Fcouchbase%2Fdata'

curl -v -X POST \
http://$varip:8091/settings/web \
-d 'password=password&username=Administrator&port=SAME'

curl -u Administrator:password -v -X POST \
http://$varip:8091/pools/default/buckets \
-d 'flushEnabled=1&threadsNumber=3&replicaIndex=0&replicaNumber=0&evictionPolicy= \
valueOnly&ramQuotaMB=597&bucketType=membase&name=default&authType=sasl&saslPassword='

curl -u Administrator:password -X POST  \
http://$varip:8091/pools/default \
-d 'memoryQuota=1024' -d 'indexMemoryQuota=256'

echo 'COUCHBASEDB created with username Administrator and password password CHANGE THIS ASAP'

echo 'COUCHBASEDB Started'
