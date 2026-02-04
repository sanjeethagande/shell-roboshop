#!/bin/bash

source ./common.sh

dnf install mysql-server -y

systemctl enable mysqld
VALIDATE $? "enabling Mysql server"

systemctl start mysqld  
VALIDATE $? "starting  Mysql server"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Installing Mysql server"