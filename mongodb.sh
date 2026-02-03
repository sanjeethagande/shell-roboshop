#!/bin/bash
USER_Id=$(id -u)
LOGS_FOLDER="/var/log/Shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m" 
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

if [ $USER_Id -ne 0 ]; then
echo -e "$R please run this script with root access $N " |tee -a $LOGS_FILE
exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE() {
if [ $1 -ne 0 ]; then
echo -e "$2..$R FAILURE $N" |tee -a $LOGS_FILE
exit 1
else 
echo -e "$2..$G SUCCESS $N" |tee -a $LOGS_FILE
fi

}

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