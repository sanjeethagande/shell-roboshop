#!/bin/bash

SCRIPT_DIR=$PWD

source ./common.sh

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "Disabling nodejs default version"

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "Enabling nodejs 20"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "installing nodejs"

id roboshop &>>$LOGS_FILE
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Creating system user"
else
 echo -e "User already exist.. $Y SKIPPING $N"
 fi

mkdir -p /app 
VALIDATE $? "Creating app directory "

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading cart code " 

cd /app 

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/cart.zip
VALIDATE $? "unzipping cart code"

npm install 
VALIDATE $? "installation started"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service

systemctl daemon-reload

systemctl enable cart 
VALIDATE $? "enabled cart"

systemctl start cart
VALIDATE $? "started  cart"

