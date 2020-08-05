#!/bin/bash
sudo chown 1000 /data/jenkins/
docker-compose -f jenkins.yml up -d
