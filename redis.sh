#!/bin/bash

source ./common.sh

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disabling redis default version"

dnf module enable redis:7 -y  &>>$LOGS_FILE
VALIDATE $? "enabling redis-7 version"


dnf install redis -y  &>>$LOGS_FILE
VALIDATE $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGS_FILE
VALIDATE $? "enabling redis"


systemctl start redis &>>$LOGS_FILE
VALIDATE $? "starting redis"
