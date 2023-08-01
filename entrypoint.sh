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

mkdir actions-runner && cd actions-runner \
	&& curl -o actions-runner-linux-x64-2.307.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.307.1/actions-runner-linux-x64-2.307.1.tar.gz \
	&& tar xzf ./actions-runner-linux-x64-2.307.1.tar.gz \
	&& rm -rf ./actions-runner-linux-x64-2.307.1.tar.gz \
	&& ./config.sh --url https://github.com/dolorestec --token ADY2XEDCD7BDMP776KLHX6TEZF7GQ \
	&& ./run.sh