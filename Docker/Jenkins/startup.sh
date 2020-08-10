#!/bin/bash
mkdir -p /data/jenkins
sudo chown 1000 /data/jenkins/
docker-compose -f jenkins.yml up -d
