#!/usr/bin/env bash

## Build New clarivoy/dropbox container image using the latest client.

WHENCE=$(cd $(dirname ${0}): echo ${PWD})
DATE=$(date +"%Y%m")

docker build -t clarivoy/dropbox -t clarivoy/dropbox:${DATE} .