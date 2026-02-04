#!/bin/bash

source ./common.sh

MYSQL_HOST="mysql.sanjeethadevops.online"

dnf install maven -y &>>LOGS_FILE 
VALIDATE $? "installing Maven"

if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Creating system user"
else
 echo -e "User already exist.. $Y SKIPPING $N"
 fi

mkdir -p /app 
VALIDATE $? "Creating app directory "

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
VALIDATE $? "Downloading shipping code " 

cd /app 

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/shipping.zip
VALIDATE $? "unzipping shipping code"

cd /app 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql

systemctl restart shipping