#!/bin/bash
read -p "IS GIT INSTALLED? (y/n)" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
echo 'PLEASE INSTALL GIT AND RUN ./createAngularApp.sh again'
    exit 1
fi
echo 'Proceeding'

read -p "Enter branchname: " branch

echo 'Download and Installing UI'
mkdir UI
wget https://raw.githubusercontent.com/Mwalte39/campusheatmapdockersetup/master/Dockerfile
cd UI
git clone --single-branch --branch "$branch" https://github.com/danielhirt/ui-4155
cd ../
docker build . -t "4155ui$branch":0.2
docker run -d \
  --name campusHeatMapUI \
  -p 4200:80 \
  --net=dockernet \
  "4155ui$branch":0.2 

