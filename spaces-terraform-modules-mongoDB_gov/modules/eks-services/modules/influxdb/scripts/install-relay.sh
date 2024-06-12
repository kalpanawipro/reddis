#!/usr/bin/env bash

exec > >(tee /var/log/install-relay.log|logger -t user-data -s 2>/dev/console) 2>&1

amazon-linux-extras enable nginx1

yum clean metadata

yum -y install nginx

service nginx start 