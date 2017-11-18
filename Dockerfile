FROM debian AS build

ENV FAST_SGA_VERSION 6042fe77f28695705c11ccbd3f4993ad4fa5459d

ADD image/bin/install /usr/local/bin

RUN fsga.sh
