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
echo 'COUCHBASEDB Started'
echo 'COUCHBASEDB created with username and password admin CHANGE THIS ASAP'
