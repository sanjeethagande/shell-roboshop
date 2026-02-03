#!/bin/bash

source ./common.sh

dnf module disable nodejs -y
VALIDATE $? "disabled nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enabled nodejs"

dnf install nodejs -y
VALIDATE $? "installing nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

mkdir /app 
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip
npm install 
VALIDATE $? "installation started"

cp catalogue.repo /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue 
VALIDATE $? "enabled catalogue"

systemctl start catalogue
VALIDATE $? "started  catalogue"