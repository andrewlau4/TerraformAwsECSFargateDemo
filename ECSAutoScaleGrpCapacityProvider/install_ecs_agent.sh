#!/bin/bash

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html

# sudo amazon-linux-extras disable docker
# sudo amazon-linux-extras install -y ecs; sudo systemctl enable --now ecs
# curl -s http://localhost:51678/v1/metadata | python -mjson.tool

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html

# see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
#  if you start this file with #!, you don't need to use  sudo
#    Scripts entered as user data are run as the root user, so do not use the sudo command in the script
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

#sudo yum install -y ecs-init
#sudo service docker start
#sudo service ecs start
yum install -y ecs-init
service docker start
service ecs start
curl -s http://localhost:51678/v1/metadata | python3 -mjson.tool
# yum install -y aws-cli