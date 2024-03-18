#!/bin/bash
apt -y install git
cd /
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

mv /tmp/puma.service /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl start puma.service
systemctl enable puma.service

PORT=`ps -aux |grep puma | grep reddit | awk '{print $13}' | tr -d "()" | awk -F ":" '{print $3}'`
sleep 10

if [ -n "$PORT"  ]; then
CHECK_REDDIT=`curl localhost:$PORT |grep "Monolith Reddit"`

  if [ -n "$CHECK_REDDIT"  ]; then
  echo "---Reddit started---"
  else echo "---Reddit not started---"
  fi

else echo "---Reddit not started, port not found---"
fi
