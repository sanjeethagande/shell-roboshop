#!/bin/bash

source ./common.sh

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "coping monogo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "installing  monogoDB"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "enabled  monogoDB"

systemctl start mongod 
VALIDATE $? "started  monogoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allwoign remote connections"

systemctl restart mongod
VALIDATE $? "restarted  monogoDB"