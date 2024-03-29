#!/bin/bash
cd ../terraform/stage
APP_IP=`terraform output |grep app -A 1 | awk -F '"' '{print $2}'`
DB_IP=`terraform output |grep db -A 1 | awk -F '"' '{print $2}'`
APP_IP_FORMAT=`echo $APP_IP |tr -d ' '`
APP_DB_FORMAT=`echo $DB_IP |tr -d ' '`

#Т.к. в предыдущем задании для обеспечения безопасности, я убрал внешний адрес для ВМ с БД, то здесь добавится локальный адрес в инвентори

cat<<EOF
{
    "app": {
      "hosts": [
        "$APP_IP_FORMAT"]
    },
    "db": {
      "hosts": [
        "$APP_DB_FORMAT"]
    }
  }
EOF
