#!/bin/bash


source ./common.sh       # calling a shell script

check_root              # calling function

echo "please enter DB password"
read -s mysql_root_password



dnf install mysql-server -y &>>$LOGFILE
#VALIDATE $? "Installing MYSQL"

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting MYSQL server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE    # setting up mysql root password
# VALIDATE $? "setting up root password"

# below command will be useful for idempotent  nature
mysql -h mysql.devopsnavyahome.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    #VALIDATE $? "MYSQL root password setup"
else
    echo -e "MYSQL root password is already set up.... $Y SKIPPING $N"
fi