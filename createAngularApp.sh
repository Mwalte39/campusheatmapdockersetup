#!/bin/bash
read -p "IS GIT INSTALLED? (y/n)" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
echo 'PLEASE INSTALL GIT AND RUN ./createAngularApp.sh again'
    exit 1
fi

echo 'proceeding'

read -p "Enter branchname: " branch

echo 'Download and Installing UI'
mkdir UI
wget https://raw.githubusercontent.com/Mwalte39/campusheatmapdockersetup/master/Dockerfile
cd UI
rm -r ui-4155
git clone --single-branch --branch "$branch" https://github.com/danielhirt/ui-4155
cd ../
docker build . -t "4155ui$branch":0.8
docker run -d \
  --name campusHeatMapUI \
  -p 4200:80 \
  --restart always \
  --net=dockernet \
  --name grafana \
  "4155ui$branch":0.25
  
docker run -d \
  --name campusHeatMapAPI \
  --restart always \
  -p 8080:8080 \
  --net=dockernet \
  dhirt/4155-repo:api-deploy-v13
