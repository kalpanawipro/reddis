#!/bin/bash
exec > >(tee /var/log/mongodb_install.log|logger -t user-data -s 2>/dev/console) 2>&1

typeOfDiskValues=`lsblk | grep nvme | grep -v nvme0 | awk '{print $1}'`
typeOfDiskCount=`lsblk | grep nvme | grep -v nvme0 | wc -l`

mkdir -p /mnt/data/mongodb

if [[ $typeOfDiskCount > 0 && ${useLocalDisk} == "true" ]]; then
    for i in $typeOfDiskValues 
    do
        allDisk+="/dev/$i "
    done
    echo "The total disks are $allDisk"
    mdadm --create --verbose /dev/md0 --level=0 --raid-devices=$typeOfDiskCount $allDisk --force
    mkfs /dev/md0
    mount /dev/md0 /mnt/data/mongodb

elif [[ ${useLocalDisk} == "true"  ]]
then
    echo "There are no local disks. But user selected to use the local disk for instance. Hence exiting"
fi

if [[ ${useLocalDisk} == "false" ]]; then
    echo "Creating filesystem and Mounting the EBS volume to mount mount"
    mkfs /dev/sdg
    mount /dev/sdg /mnt/data/mongodb
fi

echo "Mong repo is ${mongo_repo}"
echo "${mongo_repo}" > "/etc/yum.repos.d/mongodb-enterprise-7.0.repo"

yum update -y

yum install -y mongodb-enterprise

mkdir -p /mnt/data/mongodb/logs
mkdir -p /mnt/data/mongodb/db


echo "${mongo_conf}" > "/etc/mongod.conf"

echo "${pem_file}" > "/etc/ssl/devgov.ciscospaces.io.pem"

echo "updated the config of mongodb"

mongod --config /etc/mongod.conf &