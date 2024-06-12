#!/usr/bin/env bash
exec > >(tee /var/log/setup-influxdb-dms.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Received keys are admin password is ${admin_password} and user password is ${password}"

echo "Creating Bucket in influx"

influx bucket create -n ${bucket_name}/autogen -o ${org}-org -r ${retention_period} -t ${token_details}

echo "Creating bucket list in influx"

bucketid=`influx bucket list -n ${bucket_name}/autogen  -o ${org}-org -t ${token_details} --hide-headers | awk '{print $1}'`
influx v1 dbrp create -t ${token_details} \
  --db metricsdb \
  --rp autogen \
  --bucket-id $bucketid \
  -o ${org}-org \
  --default

echo "Triggering auth create command"

influx v1 auth create -t ${token_details} \
  --read-bucket $bucketid \
  --write-bucket $bucketid \
  -o ${org}-org \
  --username ${user} \
  --password ${password}