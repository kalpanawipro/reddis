#!/bin/bash
exec > >(tee /var/log/kafka_setup.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y
#sudo yum install java-1.8.0-openjdk-devel.x86_64 -y
#sudo yum install java-11-openjdk -y
sudo sudo amazon-linux-extras install java-openjdk11 -y
sleep 10
sudo unlink /etc/alternatives/java
sudo ln -s /usr/lib/jvm/java-11-openjdk-11.0.21.0.9-1.amzn2.0.1.x86_64/bin/java /etc/alternatives/java

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.21.0.9-1.amzn2.0.1.x86_64/"
export PATH="$PATH:$JAVA_HOME/bin"

typeOfDiskValues=`lsblk | grep nvme | grep -v nvme0 | awk '{print $1}'`
typeOfDiskCount=`lsblk | grep nvme | grep -v nvme0 | wc -l`
mkdir -p /mnt/data

if [[ $typeOfDiskCount > 0 && ${useLocalDisk} == "true" ]]; then
    for i in $typeOfDiskValues 
    do
        allDisk+="/dev/$i "
    done
    echo "The total disks are $allDisk"
    mdadm --create --verbose /dev/md0 --level=0 --raid-devices=$typeOfDiskCount $allDisk --force
    mkfs /dev/md0
    mount /dev/md0 /mnt/data

elif [[ ${useLocalDisk} == "true"  ]]
then
    echo "There are no local disks. But user selected to use the local disk for instance. Hence exiting"
fi

if [[ ${useLocalDisk} == "false" ]]; then
    echo "Creating filesystem and Mounting the EBS volume to mount mount"
    mkfs /dev/sdf
    mount /dev/sdf /mnt/data
fi

###END OF Mounting the disk #####

echo "Setting hostname"
echo "Cluster name is ${clusterName}"

hostname=`hostname`

mkdir -p /mnt/data/kafka-logs
mkdir -p /mnt/data/logs
mkdir -p /mnt/data/zookeeper

# firstNum=`echo ${first_set} | cut -d'_' -f2`
firstNum=100

echo "Total number of instances is ${totalInstance}"
instance_details=""
bootstrapServer=""
echo "The first num is $firstNum"
for ((i=0; i<=(${totalInstance}-1); i++))
do
    echo "Entered the for loop $i"
    instance_details+="${clusterName}$(($firstNum + $i)):2181,"
    bootstrapServer+="${clusterName}$(($firstNum + $i)):9092,"
done

echo "The final instances string is $instance_details"
echo "The final bootstrapServer string is $bootstrapServer"


#  && wget https://archive.apache.org/dist/kafka/2.7.1/kafka_2.13-2.7.1.tgz
cd /opt

aws s3 cp s3://kafkaconfigsetup/kafka_2.13-2.7.1.tgz .

tar xvzf kafka_2.13-2.7.1.tgz 

export KAFKA_VERSION=kafka_2.13-2.7.1
export DAEMON_PATH=kafka_2.13-2.7.1
cd kafka_2.13-2.7.1

mkdir -p /tmp/zookeeper/

sed -i "/broker.id=/c\broker.id=${brokerID}" config/server.properties
sed -i "/^#listeners=/c\listeners=PLAINTEXT://$hostname:9092" config/server.properties
sed -i "/advertised.listeners=/c\advertised.listeners=PLAINTEXT://$hostname:9092" config/server.properties
sed -i "/zookeeper.connect=/c\zookeeper.connect=$instance_details" config/server.properties
sed -i "/num.network.threads=/c\num.network.threads=4" config/server.properties
sed -i "/bootstrap.servers=/c\bootstrap.servers=$bootstrapServer" config/producer.properties
sed -i "/bootstrap.servers=/c\bootstrap.servers=$bootstrapServer" config/consumer.properties
sed -i "/bootstrap.servers=/c\bootstrap.servers=$bootstrapServer" config/connect-distributed.properties
sed -i "/dataDir=/c\dataDir=\/mnt\/data\/zookeeper" config/zookeeper.properties
sed -i "/log.dirs=/c\log.dirs=\/mnt\/data\/kafka-logs" config/server.properties
sed -i "/num.recovery.threads.per.data.dir=/c\num.recovery.threads.per.data.dir=4" config/server.properties
sed -i "/log.retention.hours/c\#log.retention.hours=30" config/server.properties
sed -i "/zookeeper.connection.timeout.ms/c\zookeeper.connection.timeout.ms=30000" config/server.properties
sed -i "/num.partitions/c\num.partitions=1" config/server.properties
sed -i "/socket.receive.buffer.bytes/c\socket.receive.buffer.bytes=-1" config/server.properties
sed -i "/socket.send.buffer.bytes/c\socket.send.buffer.bytes=-1" config/server.properties
sed -i "/offsets.topic.replication.factor=/c\offsets.topic.replication.factor=3" config/server.properties
sed -i "/transaction.state.log.replication.factor=/c\transaction.state.log.replication.factor=3" config/server.properties
sed -i "/transaction.state.log.min.isr=/c\transaction.state.log.min.isr=2" config/server.properties
sed -i "/group.initial.rebalance.delay.ms=/c\group.initial.rebalance.delay.ms=30000" config/server.properties

for ((i=0; i<=(${totalInstance}-1); i++))
do
    echo "server.$i=${clusterName}$(($firstNum + $i)):2889:3889"  >> config/zookeeper.properties
done

for (( i=0;i<=${totalInstance}-1;i++ ))
do
        echo "Reached inside the instances"
        if [[ "${clusterName}$(($firstNum + $i))" == $hostname ]]
        then
                echo "$hostname found at index $i"
                echo "$i"  > /mnt/data/zookeeper/myid
                break
        fi
done

echo -e "vm.swappiness=1\nvm.dirty_ratio=80\nvm.dirty_background_ratio=5\vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl --system

echo "/opt/$KAFKA_VERSION/bin/zookeeper-server-start.sh /opt/$KAFKA_VERSION/config/zookeeper.properties > /opt/$KAFKA_VERSION/zookeeper_log.out 2>&1 &" >> zookeeper.sh

# if [[ ${ssl_enabled} == true ]]; then
# echo "ssl.keystore.location=/usr/etc/ssl/server.keystore.jks
# ssl.keystore.password=CIsc0133@@
# ssl.key.password=CIsc0133@@
# ssl.truststore.location=/usr/etc/ssl/server.truststore.jks
# ssl.truststore.password=CIsc0133@@
# inter.broker.listener.name=SSL" >> config/server.properties
# fi

echo "offsets.retention.minutes=10080
message.max.bytes=31457280
replica.fetch.max.bytes=31457280
group.max.session.timeout.ms=1200000
request.timeout.ms=600000
connections.max.idle.ms=1080000
min.insync.replicas=1
default.replication.factor=3
delete.topic.enable=true
num.replica.fetchers=2
log.retention.minutes=30" >> config/server.properties

echo "* soft nofile 131072
* hard nofile 262144" >>  /etc/security/limits.conf

echo "tickTime=2000
initLimit=5
syncLimit=2" >> config/zookeeper.properties

echo "[Unit] 
Description=Zookeeper Agent
After=network.target

[Service]
Type=simple
ExecStart=/opt/$KAFKA_VERSION/zookeeper.sh
KillMode=process
Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/zookeeper.service 

echo "[Unit] 
Description=Kafka agent
After=network.target

[Service]
Type=simple
ExecStartPre=/opt/$KAFKA_VERSION/broker.sh start
ExecStart=/opt/$KAFKA_VERSION/bin/kafka-topics.sh --create --bootstrap-server $bootstrapServer --replication-factor 2 --partitions 36 --topic terraform-topic-kafka 
KillMode=process
Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/kafkatopics.service 

echo "Successfully completed the setup"

BASEDIR=$(dirname "$0")
echo "The script execution is in $BASEDIR"

echo '${kafka_script}' >> /opt/$KAFKA_VERSION/broker.sh

echo "Copied the script file"

cd /opt/$KAFKA_VERSION

chmod 777  /opt/kafka_2.13-2.7.1/zookeeper.sh
chmod 755 -R /opt/kafka_2.13-2.7.1/

# service zookeeper start

# sleep 10

# service kafkatopics start

sh zookeeper.sh &

sleep 10

sh broker.sh start &

#echo "Creating the topcis....."

cd /opt/$KAFKA_VERSION/bin/

./kafka-topics.sh --create --bootstrap-server $bootstrapServer --replication-factor 2 --partitions 36 --topic terraform-topic-kafka
