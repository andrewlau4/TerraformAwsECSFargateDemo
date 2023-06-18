#!/bin/bash

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html

# sudo amazon-linux-extras disable docker
# sudo amazon-linux-extras install -y ecs; sudo systemctl enable --now ecs
# curl -s http://localhost:51678/v1/metadata | python -mjson.tool

sudo yum install -y ecs-init
sudo service docker start
sudo service ecs start
curl -s http://localhost:51678/v1/metadata | python3 -mjson.tool