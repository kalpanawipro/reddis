#!/usr/bin/env bash
exec > >(tee /var/log/install-influxdb.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Received keys are password is ${password}"
echo "content of repo is ${content}"
echo "${content}" >> /etc/yum.repos.d/influxdb.repo
typeOfDiskValues=`lsblk | grep nvme | grep -v nvme0 | awk '{print $1}'`
typeOfDiskCount=`lsblk | grep nvme | grep -v nvme0 | wc -l`
mkdir -p /var/lib/influxdb/engine

yum install vim -y

if [[ $typeOfDiskCount > 0 && ${useLocalDisk} == "true" ]]; then
    for i in $typeOfDiskValues 
    do
        allDisk+="/dev/$i "
    done
    echo "The total disks are $allDisk"
    mdadm --create --verbose /dev/md0 --level=0 --raid-devices=$typeOfDiskCount $allDisk --force
    mkfs /dev/md0
    mount /dev/md0 /var/lib/influxdb/engine

elif [[ ${useLocalDisk} == "true"  ]]
then
    echo "There are no local disks. But user selected to use the local disk for instance. Hence exiting"
fi

if [[ ${useLocalDisk} == "false" ]]; then
    echo "Creating filesystem and Mounting the EBS volume to mount mount"
    mkfs /dev/xvdf
    mount /dev/xvdf /var/lib/influxdb/engine
fi


function mount_volume {
  device_name=$1
  mount_point=$2
  if [[ `blkid $device_name` != *"ext4"* ]]; then
    echo "Make file system"
    mkfs -t ext4 $device_name
  fi
  if [ ! -d $mount_point ]; then
    mkdir -p $mount_point
  fi
  if ! grep $device_name /etc/mtab > /dev/null; then
    mount $device_name $mount_point
  fi
  if ! grep $mount_point /etc/fstab > /dev/null; then
    echo "$device_name $mount_point ext4 defaults,nofail 0 2" >> /etc/fstab
  fi
  chown -R influxdb:influxdb $mount_point
}

umask 0022

sysctl -w vm.max_map_count=${influxdb_memory_limit}
ulimit -m ${influxdb_memory_limit}

# yum install -y influxdb2
# chkconfig influxdb on

cd /tmp/.
wget https://dl.influxdata.com/enterprise/releases/fips/influxdb-data-1.11.5_c1.11.5-1.x86_64.rpm
rpm -Uvh influxdb-data-1.11.5_c1.11.5-1.x86_64.rpm --nodigest --nofiledigest
service influxdb start

# cat << EOF > /etc/influxdb/config.toml
# engine-path = "/var/lib/influxdb/engine"
# storage-series-id-set-cache-size =  100
# http-bind-address =  ":8086"
# http-write-timeout = "100s"
# storage-write-timeout = "100s"
# EOF

# chown -R influxdb:influxdb /var/log/influxdb/
# chown -R influxdb:influxdb /var/lib/influxdb/
# service influxdb stop
# service influxdb start

# influx setup \
#   --org ${org}-org \
#   --bucket ${bucket_name} \
#   --username ${admin} \
#   --password ${password} \
#   -t ${token_details} --force

# echo "Influx setup is completed"