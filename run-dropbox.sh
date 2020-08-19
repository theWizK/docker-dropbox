#!/usr/bin/env bash

DHN=${HOSTNAME}-$(echo ${HOSTNAME} | sha512sum  | fold -w12 | head -1)
NAME=dropbox_${USER}

mkdir -p ~/.dropbox ~/Dropbox


docker run --rm -d --hostname ${DHN} -v ~/.dropbox:/dbox/.dropbox -v ~/Dropbox:/dbox/Dropbox -e DBOX_SKIP_UPDATE=true -e DBOX_UID=$(id -u) -e DBOX_GID=$(id -g) -e DBOX_BUSINESS_NAME=Clarivoy --name ${NAME} clarivoy/dropbox

echo "INFO: running, use docker logs -f ${NAME} to find the status / URL to link account"...
