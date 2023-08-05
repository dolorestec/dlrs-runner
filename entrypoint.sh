#!/bin/bash
########################################################################
# Project           : DLRS - Docker Image Base runner
# Maintainer        : Lucas Cantarelli
########################################################################
echo "DLRS - Github Runner"
echo "OS Info:"
echo "Image: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2)"
echo "Version: $(cat /etc/os-release | grep VERSION_ID | cut -d '=' -f2)"
echo "Runner Info:"
echo "Organization: ${RUNNER_ORGANIZATION}"
echo "Name: ${RUNNER_NAME}"
echo "Workdir: ${RUNNER_WORKDIR}"
echo "Repository: ${RUNNER_REPOSITORY}"
echo "URL: ${RUNNER_URL}"
echo "Labels: ${RUNNER_LABELS}"

echo "Configuring runner..."
./config.sh \
    --unattended \
    --url ${RUNNER_URL} \
    --token ${RUNNER_TOKEN} \
    --name ${RUNNER_NAME} \
    --runnergroup ${RUNNER_GROUP} \
    --labels ${RUNNER_LABELS} \
    $> /dev/null

echo "Starting runner..."
./run.sh