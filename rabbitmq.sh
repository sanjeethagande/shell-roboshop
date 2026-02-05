#!/bin/bash


SCRIPT_DIR=$PWD
source ./common.sh

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Added rabbitmq server"

dnf install rabbitmq-server -y &>>LOGS_FILE
VALIDATE $? "installing rabbitMQ server"

systemctl enable rabbitmq-server
VALIDATE $? "Enabling rabbitMQ server"

systemctl start rabbitmq-server
VALIDATE $? "Starting rabbitMQ server"


rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created User and gein permissions"

