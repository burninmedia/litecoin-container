#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
BUILD_VERSION=$(docker images | awk '($1 == "burninmedia/litecoin") {print $2 += .01; exit}')
docker build -t burninmedia/litecoin:${BUILD_VERSION} ./dockerfile
docker push burninmedia/litecoin:${BUILD_VERSION}