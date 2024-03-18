#!/bin/bash
sudo apt update
sudo apt install mongodb -y
sudo systemctl start mongodb
sudo systemctl enable mongodb
sleep 5
CHECK_MONGO=`systemctl list-units |grep mongo |grep running`

if [ -n "$CHECK_MONGO"  ]; then
echo "---MongoDB installed and running---"
else echo "---MongoDB not installed and running---"
fi
