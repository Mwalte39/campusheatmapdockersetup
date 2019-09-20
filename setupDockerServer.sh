#!/bin/bash
echo 'Beginning Server Setup'
wget https://raw.githubusercontent.com/Mwalte39/campusheatmapdockersetup/master/influxdb.conf
echo 'Pulling and Running INFLUXDB'
docker run --name influxdb \
  -p 8083:8083 -p 8086:8086 \
  -v $PWD/influxdb:/var/lib/influxdb \
  -v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
  -v $PWD/types.db:/usr/share/collectd/types.db:ro \
  influxdb:1.0
echo 'Pulling and Running GRAFANA'
docker run --name grafana \
  -p 3000:3000 \
  -v $PWD/grafana:/var/lib/grafana \
  --link influxdb \
  grafana/grafana:3.1.1
echo 'Restarting Influx'
docker restart influxdb
docker exec influxdb CREATE USER admin WITH PASSWORD 'admin' WITH ALL PRIVILEGES
echo 'influxdb created with username and password admin'

