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
	g++ \
	libbamtools-dev \
	libsparsehash-dev \
	libtbb-dev \
	make \
	wget \
	zlib1g-dev"

echo "deb http://http.us.debian.org/debian testing main" > /etc/apt/sources.list
apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES}


mkdir ${FSGA_DIR}
cd ${FSGA_DIR} && \
    wget --quiet ${FSGA_TAR} --no-check-certificate --output-document - \
    | tar xzf - --directory . --strip-components=2 && \
    ./autogen.sh && \
    ./configure --with-bamtools=/usr/include/bamtools/ && \
    make && \
    make install && \
    rm -rf ${FSGA_DIR}


