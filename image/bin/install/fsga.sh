#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

FSGA_TAR="https://github.com/AlgoLab/FastStringGraph/archive/${FAST_SGA_VERSION}.tar.gz"
FSGA_DIR="/tmp/fsga"

PACKAGES="\
	automake \
	ca-certificates \
	cmake \
	gcc-5 \
	g++-5 \
	libbamtools-dev \
	libboost-dev \
	libsparsehash-dev \
	libtbb-dev \
	make \
	wget \
	zlib1g-dev"

# Add repositories for older versions of gcc/g++
echo "deb http://http.us.debian.org/debian unstable main" > /etc/apt/sources.list
apt-get update --yes
apt-get install --yes --no-install-recommends ${PACKAGES}

# Specify use of older versions of gcc/g++
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

mkdir ${FSGA_DIR}
cd ${FSGA_DIR} && \
    wget --quiet ${FSGA_TAR} --no-check-certificate --output-document - \
    | tar xzf - --directory . --strip-components=2 && \
    ./autogen.sh && \
    ./configure --with-bamtools=/usr && \
    make -j $(nproc) && \
    make install
