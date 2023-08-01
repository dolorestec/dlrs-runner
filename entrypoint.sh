#!/bin/bash
########################################################################
# Project           : DLRS - Docker Image Base runner
# Maintainer        : Lucas Cantarelli
########################################################################

echo "DLRS - Docker Image Base for runner"
echo ""
echo "Image: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2)"
echo "Version: $(cat /etc/os-release | grep VERSION_ID | cut -d '=' -f2)"
echo "Workdir: ${APP_PATH}"
echo "Docker: $(docker -v)"
echo "Docker Buildx: $(docker buildx version)"
