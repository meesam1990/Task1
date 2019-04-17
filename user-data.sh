#!/bin/bash
mkfs -t xfs /dev/xvdb
mkfs -t xfs /dev/xvdc

#Create Raid10
mdadm --create --verbose /dev/md0 --level=10 --raid-devices=2 /dev/xvdb /dev/xvdc
mkfs -t xfs /dev/md0
mount /dev/md0 /mnt
echo /dev/md0 /mnt xfs defaults 0 0 >> /etc/fstab

#Install Tomcat & MongoDB
sudo apt-get update
sudo apt-get install tomcat8 -y
sudo apt-get install docker.io -y
sudo /etc/init.d/docker start
mkdir /mnt/data
sudo docker run -d -p 27017:27017 -v /mnt/data:/data/db mongo

#Monitor processes
touch ~/logs.txt
touch ~/process.sh
chmod +x ~/process.sh

cat <<EOT >> ~/process.sh
#Check if process is running
PID1=$(/bin/ps aux | grep -v grep | grep "tomcat" | awk '{print $2}')
PID2=$(/bin/ps aux | grep -v grep | grep "mongo" | awk '{print $2}')

#err=0

if [ "x$PID1" == "x" ]; then
        # PROCESS tomcat died
#        err=$(( err + 1 ))
        echo "$(date) - PROCESS tomcat8 is down" >> ~/logs.txt;
else
        echo "$(date) - PROCESS tomcat8 is Running" >> ~/logs.txt;
fi

if [ "x$PID2" == "x" ]; then
        # PROCESS mongo died
#        err=$(( err + 2 ))
        echo "$(date) - PROCESS mongo is down" >> ~/logs.txt;
else
        echo "$(date) - PROCESS mongo is Running" >> ~/logs.txt;
fi
EOT

#Configure awscli

sudo apt-get install awscli -y

mkdir ~/.aws/ && touch ~/.aws/config && echo "[default]" >> ~/.aws/config && echo "aws_access_key_id=" >> ~/.aws/config && echo "aws_secret_access_key=" >> ~/.aws/config && echo "region=ap-south-1" >> ~/.aws/config && echo "output=json" >> ~/.aws/config

aws s3api create-bucket --bucket syed-bucket --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

crontab <<EOF
* * * * * /bin/bash /root/process.sh
*/60 * * * * aws s3 cp /root/logs.txt s3://syed-bucket/Logs-`date +"%m-%d-%y-%T"`.txt --region ap-south-1
EOF

