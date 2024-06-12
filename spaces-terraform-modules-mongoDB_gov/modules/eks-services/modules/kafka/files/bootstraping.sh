#!/bin/bash
exec > >(tee /var/log/bootstrapping.log|logger -t user-data -s 2>/dev/console) 2>&1
cat /usr/share/zoneinfo/EST > /etc/localtime

yum install nfs-utils -y

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/user-data -o instance_data

export localip=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/local-ipv4"`
export publicip=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/public-ipv4"`
hname=${hostname}
hostnamectl set-hostname $hname
echo "Hostname is $hname"
echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
echo "$localip  $hname.qa.dnaspaces.io $hname" >> /etc/hosts

echo $publicip | grep -E "^[0-9][0-9][0-9].[0-9]|^[0-9][0-9].[0-9]|^[0-9].[0-9]"

sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzKwxYcSIlxy7veT03p0w72LXFDAROKaF5gaEhnS2ON35qZ//AW0QLrxp4vpQNGxvYmAEiWw66rI7KMTiNSyV7+ttuv/77LTBSoekxMggPFbpnZoReqrGDqXRkP1KTvxWIFLQd1DoxgLNLr//AwKKEIhK7Fxj5xePWvlOMwmR5gDU7kIHhEP6WHh1YfnJJHuAE8hNfLpV6bn+vFjnZMSrDou7X2f7MlhiTRfgD4Kz13DCk7t/quk0PC0eXsDiW0qi5GKjYoFB4lDRTeCqH+4YEBH8fpDXKaQhqQEBRgyOAetbiUNEUomoWOsvYR2bhjzD3TqM28tl5oL6SZ+1hOW2F root@AnsibleController200" >> /root/.ssh/authorized_keys
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
limit=1
while [ $limit -le 3 ]
do
        mkdir -p /mnt/{config,backups}
	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-042dd6888b9a66a1e.efs.ap-southeast-1.amazonaws.com:/ /mnt/config
	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-055e15dd857a3c541.efs.ap-southeast-1.amazonaws.com:/ /mnt/backups
        if [ -d /mnt/config/haproxy/ ] && [ -d /mnt/backups/release_files/ ]; then
                echo "Success: /mnt/config or /mnt/backups mounted successfully in `hostname`";
                break;
        else
                if [ $limit -eq 3 ]; then
                        echo "Failure: Instance launch failed. /mnt/config or /mnt/backups has not mounted in `hostname`. Please check the mounts.";
                        echo -e "Failure: Instance launch failed. /mnt/config or /mnt/backups has not mounted in `hostname`. Please check the mounts.\n`df -h`" | mail -s "Failure: `hostname` Instance launch failed. /mnt/config or /mnt/backups has not mounted." devops-internal@cisco.com
                        exit;
                fi
        sleep 5
        fi
        limit=`expr $limit + 1`
done

chkswap=$(free -m | grep "Swap:" | awk '{t = $2; print t}')

if [ $chkswap -eq 0 ]; then
   if [ ! -f /mnt/swapfile/swapfile1 ]; then
        #swapmem=$(free -m | grep "Mem:" | awk '{t = $2; f = 1048; print (f*t)}')
        swapmem=$(free -m | grep "Mem:" | awk '{t = $2; f = 1024; print ((t*0.5)*f)}')
        mkdir -p /mnt/swapfile
	if [[ $swapmem -ge 30457280 ]]; then
		dd if=/dev/zero of=/mnt/swapfile/swapfile1 bs=1024 count=30457280
	else
		dd if=/dev/zero of=/mnt/swapfile/swapfile1 bs=1024 count=$swapmem
	fi
        mkswap /mnt/swapfile/swapfile1
        chmod 600 /mnt/swapfile/swapfile1
        swapon /mnt/swapfile/swapfile1
        echo 3 > /proc/sys/vm/drop_caches
   else
        mkswap /mnt/swapfile/swapfile1
        chmod 600 /mnt/swapfile/swapfile1
        swapon /mnt/swapfile/swapfile1
        echo 3 > /proc/sys/vm/drop_caches
   fi
fi
#prod record Z1PYTKBUXH1SOD
aws route53 change-resource-record-sets --hosted-zone-id Z05727611AQ55Y10AGAN2 --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$hname'.'internal.ciscospaces.sg'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$localip'"}]}}]}'

aws route53 change-resource-record-sets --hosted-zone-id Z05727611AQ55Y10AGAN2 --change-batch '{"Comment":"CREATE/DELETE/UPSERT a record ","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"l-'$hname'.'internal.ciscospaces.sg'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$localip'"}]}}]}'

yum update nfs-utils -y

########## Null the history ########

>| /root/.bash_history

############## IAM SSH Config ##################
rpm -qa |grep -q "aws-ec2-ssh"
if [ $? -ne 0 ]; then
        rpm -ivh /mnt/config/iamssh/aws-ec2-ssh-1.8.0-1.el7.centos.noarch.rpm
fi
cp -rfv /mnt/config/iamssh/aws-ec2-ssh.conf /etc/aws-ec2-ssh.conf
cp -rfv /mnt/config/iamssh/import_users.sh /usr/bin/import_users.sh
chmod 755 /usr/bin/import_users.sh
bash /usr/bin/import_users.sh
sed -i "s/\(.*import_users.*$\)/#\1/g" /etc/cron.d/import_users

###-- tag the instance -- ###
instanceID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/instance-id"`
check_tag=`/usr/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$instanceID" --region ap-southeast-1 | grep -B1 '"Name"' | grep '"Value": "[a-zA-Z0-9]\+"'`
if [ -z "$check_tag" ]; then
        /usr/bin/aws ec2 create-tags --resources $instanceID --tags "Key=Name,Value=$hname" "Key=Application Name,Value=DNASpaces" "Key=Cisco Mail Alias,Value=dnaspaces-aws@cisco.com" "Key=Data Classification,Value=Cisco Confidential" "Key=Environment,Value=Prod" "Key=Resource Owner,Value=DNASpaces-AWS" --region ap-southeast-1
fi