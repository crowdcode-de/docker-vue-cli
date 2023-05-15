#!/bin/sh
# Build a docker image containing node, npm, and vue cli
#Set the required vue cli version
VUE_CLI_VERSION='3.8.0'
VERSION='1.0.0-SNAPSHOT'
docker buildx build --platform linux/amd64,linux/arm64/v8 --push -t "docker-release.crowdcode.io/builders/VUE-3.8.0-Node-18.6:${VERSION}" --build-arg VUE_CLI_VERSION=${VUE_CLI_VERSION} .