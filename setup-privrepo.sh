#!/bin/bash

PARRENT_DIR=$(cd $(dirname ${0})/.. && pwd)
RELEASE_VER=`lsb_release -r | awk '{print $2}'`
DISTRIBUTION=`lsb_release -c | awk '{print $2}'`
ARCHITECTURE=`dpkg --print-architecture`

PBUILDER_DIR=${PARRENT_DIR}/pbuilder/${DISTRIBUTION}-${ARCHITECTURE}
cat <<EOT > ~/.pbuilderrc
APTCONFDIR=/etc/apt
DISTRIBUTION=${DISTRIBUTION}
ARCHITECTURE=${ARCHITECTURE}
BASETGZ=${PBUILDER_DIR}/base.tgz
BUILDPLACE=${PBUILDER_DIR}/build/
BUILDRESULT=${PBUILDER_DIR}/result/
APTCACHE=${PBUILDER_DIR}/aptcache/
EOT

REPREPRO_CONF=${PARRENT_DIR}/reprepro/${DISTRIBUTION}-gcc-lower/conf
mkdir -p ${REPREPRO_CONF}
cat <<EOT > ${REPREPRO_CONF}/distributions
Codename: ${DISTRIBUTION}
Architectures: i386 amd64 source
Components: main
SignWith: yes
Label: GNU GCC PPA (lower version)
Suite: ${DISTRIBUTION}
Version: ${RELEASE_VER}
EOT

REPREPRO_CONF=${PARRENT_DIR}/reprepro/${DISTRIBUTION}-gcc-upper/conf
mkdir -p ${REPREPRO_CONF}
cat <<EOT > ${REPREPRO_CONF}/distributions
Codename: ${DISTRIBUTION}
Architectures: i386 amd64 source
Components: main
SignWith: yes
Label: GNU GCC PPA (upper version)
Suite: ${DISTRIBUTION}
Version: ${RELEASE_VER}
EOT

sudo apt-get -y install gnupg-agent
sudo apt-get -y install pbuilder
sudo apt-get -y install reprepro
sudo pbuilder --create
