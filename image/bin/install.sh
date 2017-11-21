#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

PACKAGES="\
	libbamtools-dev \
	libboost-dev \
	libsparsehash-dev \
	libtbb-dev"

install_packages ${PACKAGES}
