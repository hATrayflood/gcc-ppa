#!/bin/sh

sudo sh << EOC
apt-get -y install meld
apt-get -y install devscripts
apt-get -y install quilt
apt-get -y install m4
apt-get -y install debhelper

apt-get -y install g++-multilib
apt-get -y install libtool
apt-get -y install autoconf2.64
apt-get -y install automake
apt-get -y install zlib1g-dev
apt-get -y install gawk
apt-get -y install gperf
apt-get -y install bison
apt-get -y install flex
apt-get -y install texinfo
apt-get -y install sharutils
apt-get -y install libcloog-ppl-dev
apt-get -y install libmpc-dev
apt-get -y install libmpfr-dev
apt-get -y install libgmp-dev
apt-get -y install libelfg0-dev
apt-get -y install dejagnu
apt-get -y install autogen
apt-get -y install realpath
apt-get -y install chrpath
apt-get -y install doxygen
apt-get -y install graphviz
apt-get -y install gsfonts-x11
apt-get -y install texlive-latex-base
EOC
