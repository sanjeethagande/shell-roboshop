#!/bin/bash

SCRIPT_DIR=$PWD
source ./common.sh

dnf install python3 gcc python3-devel -y &&>>LOGS_FILE
VALIDATE $? "Added rabbitmq server"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Added system user"

mkdir /app 
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
cd /app 
unzip /tmp/payment.zip
pip3 install -r requirements.txt
VALIDATE $? "Enabling and starting payment"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service
VALIDATE $? "Enabling and starting payment"

systemctl daemon-reload
VALIDATE $? "reload payment"
systemctl enable payment 
systemctl start payment
VALIDATE $? "Enabling and starting payment"


