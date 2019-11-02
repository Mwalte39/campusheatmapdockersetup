#!/bin/bash
echo 'Beginning Server Setup'
mkdir campusHeatMapServices
cd campusHeatMapServices
echo 'creating dockernet'
docker network create -d bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 dockernet
echo 'Getting createAngularApp.sh'
wget https://raw.githubusercontent.com/Mwalte39/campusheatmapdockersetup/master/createAngularApp.sh
echo 'Pulling and Running INFLUXDB'
docker run -d \
  --name influxdb \
  --name grafana \
  --net=dockernet \
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
mkdir grafana
chown 472:472 grafana
docker run -d \
  --name grafana \
  --restart always \
  --net=dockernet \
  -p 3000:3000 \
  -v $PWD/grafana:/var/lib/grafana \
  --link influxdb \
  grafana/grafana:6.4.3
echo 'Grafana Starting'
sleep 30s
echo 'Grafana Started'
echo 'Adding Admin for Influx'
docker restart influxdb
echo 'influxdb created with username and password admin CHANGE THIS ASAP'

echo 'Executing createAngularApp.sh'
chmod 777 ./createAngularApp.sh
./createAngularApp.sh
