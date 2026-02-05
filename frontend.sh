#!/bin/bash

SCRIPT_DIR=$PWD

source ./common.sh

dnf module disable nginx -y &>>LOGS_FILE
VALIDATE $? "Disbling nginx"

dnf module enable nginx:1.24 -y &>>LOGS_FILE
dnf install nginx -y
VALIDATE $? "Enabling nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "Started nginx"

rm -rf /usr/share/nginx/html/* 

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Downloading nginx"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzipping nginx"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf

systemctl restart nginx 
VALIDATE $? "Restarted nginx"