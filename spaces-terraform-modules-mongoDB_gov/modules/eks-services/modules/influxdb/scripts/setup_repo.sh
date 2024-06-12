#!/bin/bash

exec > >(tee /var/log/setup_repo.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "content of repo is ${content}"

echo "${content}" >> /etc/yum.repos.d/influxdb.repo

sudo chown root:root /etc/yum.repos.d/influxdb.repo

mkdir -p /etc/nginx/ 

echo "Content of conf is ${relayConf}"

echo "${relayConf}" > /etc/nginx/nginx.conf
