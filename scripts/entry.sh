#!/bin/bash
set -e

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install --nobest -y docker-ce jq python2 libffi-devel libseccomp-devel libuv

mkdir -p bin dist
if [ -e ./scripts/$1 ]; then
    ./scripts/"$@"
else
    exec "$@"
fi

chown -R $DAPPER_UID:$DAPPER_GID .
