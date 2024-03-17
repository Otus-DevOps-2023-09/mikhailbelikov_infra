#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

ruby -v && echo "---Ruby installed---"
bundler -v  && echo "---Bundler installed---"
