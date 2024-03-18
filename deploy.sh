#!/bin/bash
sudo apt -y install git
cd ~
rm -rf reddit
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

PORT=`ps -aux |grep puma | grep reddit | awk '{print $13}' | tr -d "()" | awk -F ":" '{print $3}'`

if [ -n "$PORT"  ]; then
sleep 10
CHECK_REDDIT=`curl localhost:$PORT |grep "Monolith Reddit"`

  if [ -n "$CHECK_REDDIT"  ]; then
  echo "---Reddit started---"
  else echo "---Reddit not started---"
  fi

else echo "---Reddit not started, port not found---"
fi
