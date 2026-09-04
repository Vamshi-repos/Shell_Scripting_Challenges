#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

R="\e[31m"
G="\e[32m"


if [ $USERID -ne 0 ]; then
   echo -d "$R Please run  the sccript with ROOT user $N" | tee -a $LOGS_FILE
   exit 1
fi 

mkdir -p $LOGS_FOLDER

VALIDATE(){
   if [ $1 -ne 0 ]; then
       echo -e "$2 ..... $3 FAILURE $N" | tee -a $LOGS_FILE
       exit 1
    else
       echo -e " $2 ..... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}


cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$LOGS_FILE
VALIDATE $? "Copying Package Installation REPOS"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing Mongodb Server"

systemctl enable mongodb &>>$LOGS_FILE
VALIDATE $? "Enable Mongodb service"

systemctl start mongodb &>>$LOGS_FILE
VALIDATE $? "Started ting Mongodb service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "updating mongod conf file to alloW all connections from default 127.0.0.1 to 0.0.0.0"

systemctl restart mongodb 
VALIDATE $? "Restarted  Mongodb service"

