#!/bin/bash


source ./common.sh       # calling a shell script

check_root              # calling function


echo "please enter DB password:"
read -s mysql_root_password



dnf module disable nodejs -y &>>$LOGFILE

dnf module enable nodejs:20 -y &>>$LOGFILE


dnf install nodejs -y &>>$LOGFILE


id expense  &>>$LOGFILE                     
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE                            # useradd expense command is not idempotency so we are changing the code
else   
    echo -e "Expense user already created..... $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE 


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE 

cd /app

rm -rf /app/*                 #everytime if you unzip a folder which is already unziped, it will throw a error. so before unziping remove all the file in that directory and then unzip it 

unzip /tmp/backend.zip &>>$LOGFILE 


npm install &>>$LOGFILE 


cp /home/ec2-user/expense-shellscript/backend.service /etc/systemd/system/backend.service &>>$LOGFILE 



systemctl daemon-reload &>>$LOGFILE 


systemctl start backend &>>$LOGFILE 

systemctl enable backend &>>$LOGFILE 


dnf install mysql -y &>>$LOGFILE 


mysql -h mysql.devopsnavyahome.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE   # mysql.devopsnavyahome.online---mysql BD server ip ----configure in R53, A--record


systemctl restart backend &>>$LOGFILE 
