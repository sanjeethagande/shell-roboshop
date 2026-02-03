#!/bin/bash

SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.sanjeethadevops.online"

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

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading catalogue code " 

cd /app 

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/catalogue.zip
VALIDATE $? "unzipping catalogue code"

npm install 
VALIDATE $? "installation started"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue 
VALIDATE $? "enabled catalogue"

systemctl start catalogue
VALIDATE $? "started  catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo


dnf install mongodb-mongosh -y
VALIDATE $? "Installing"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getNames.().indexof("catalogue")')

if [ $INDEX -le 0 ]; then
mongosh --host $MONGODB_HOST </app/db/master-data.js
VALIDATE $? "Loading Products"
else
echo -e "products already loaded...$Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "restarted"

# mongosh --host $MONGODB_HOST
# VALIDATE $? ""

# show dbs
# VALIDATE $? "Showing Databases"

# use catalogue
# VALIDATE $? "catalogue table"

# show collections
# VALIDATE $? "showing collections"

# db.products.find()
# VALIDATE $? "catalogue products"