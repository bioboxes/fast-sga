FROM debian:jessie

ENV FAST_SGA_VERSION 6042fe77f28695705c11ccbd3f4993ad4fa5459d

ADD image/bin/install /usr/local/bin
RUN fsga.sh



FROM bitnami/minideb:stretch

COPY --from=0 /usr/local/bin /usr/local/bin
COPY --from=bioboxes/biobox-minimal-base@sha256:b73428dee585232350ce0e30d22f97d7d22921b74b81a4196d246ca2da3cb0f5 \
       /usr/local/bin \
       /usr/local/bin

ADD image/bin    /usr/local/bin
ADD image/share  /usr/local/share

RUN install.sh && \
    rm /usr/local/bin/install.sh && \
    rm -r /usr/local/bin/install

ENV TASKFILE     /usr/local/share/Taskfile
ENV SCHEMA       /usr/local/share/assembler_schema.yaml
ENV BIOBOX_EXEC  assemble.sh

ENV INPUT     /bbx/input/biobox.yaml
ENV OUTPUT    /bbx/output
ENV METADATA  /bbx/metadata

ENTRYPOINT ["validate_inputs.sh"]
