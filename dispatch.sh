#!/bin/bash

source ./common.sh

dnf install golang -y
VALIDATE $? "installing  Goloang"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "User added"

mkdir /app 
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip 
cd /app 
unzip /tmp/dispatch.zip
VALIDATE $? "Downlowded and unzipped"

cd /app 
go mod init dispatch
VALIDATE $? "Dispatched"

go get 
go build
VALIDATE $? "Build started"

systemctl enable dispatch 
systemctl start dispatch
VALIDATE $? "installing  monogoDB"
