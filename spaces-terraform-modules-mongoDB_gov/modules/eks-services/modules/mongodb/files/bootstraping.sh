#!/bin/bash
exec > >(tee /var/log/bootstrapping.log|logger -t user-data -s 2>/dev/console) 2>&1
cat /usr/share/zoneinfo/EST > /etc/localtime

yum install nfs-utils -y

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/user-data -o instance_data
#wget -q -O instance-data "http://169.254.169.254/latest/user-data"

export localip=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/local-ipv4"`
echo 'localip:'$localip

export publicip=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/public-ipv4"`
echo "Publicip is $publicip"

# userdata=`cat instance_data | grep 'hostname_details:' | cut -d~ -f2 | head -1`   #`cut -d~ -f 1 instance-data`
echo "Value of hostnmae is $hname"
index=100

echo "Value of host is $hname and $index \n"
# hname=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://l-chefserver:8080/aws/portal.py?portalName=$hname,$index"`
hostname $hname
echo "Hostname is $hname"
# export $hname

echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
echo "$localip  $hname.internal.dnaspaces.io $hname" >> /etc/hosts

echo $publicip | grep -E "^[0-9][0-9][0-9].[0-9]|^[0-9][0-9].[0-9]|^[0-9].[0-9]"

####### Route 53 DNS Update ########

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"master-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"l-master-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"slave-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"l-slave-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"arbritary-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z085110018R364CSRT55Q --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"l-arbritary-mongodb-devgov.ciscospaces.io","Type":"A","TTL":300,"ResourceRecords":[{"Value":"1.1.1.1"}]}}]}'
############ update nfs-utils ############

yum update nfs-utils -y

########## Null the history ########

>| /root/.bash_history

