#!/bin/bash
set -e

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install --nobest -y docker-ce jq python2 libffi-devel libseccomp-devel libuv glibc-static sqlite sqlite-libs gcc rpm-build

dnf download --source sqlite-libs
rpm -ivh sqlite-*src.rpm
rpmbuild -bp ~/rpmbuild/SPECS/sqlite.spec
cd ~/rpmbuild/BUILD/sqlite-src-*
dnf builddep -y ~/rpmbuild/SPECS/sqlite.spec
./configure
make
cp .libs/libsqlite3.a /usr/lib64

mkdir -p bin dist
if [ -e ./scripts/$1 ]; then
    ./scripts/"$@"
else
    exec "$@"
fi

chown -R $DAPPER_UID:$DAPPER_GID .
