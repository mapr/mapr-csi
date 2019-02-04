# Copyright (c) 2009 & onwards. MapR Tech, Inc., All rights reserved

# Ubuntu Package Build
FROM ubuntu:16.04
LABEL mapr.os=ubuntu16
ENV container docker

# Setup repos and dl prereqs + Mapr Core
WORKDIR /tmp
# dl prereqs
RUN apt-get update; \
    apt-get install -y apt-utils sudo lsb-release; \
    DEBIAN_FRONTEND=noninteractive apt-get install --allow-unauthenticated -y wget perl syslinux openjdk-8-jdk
# Install MapR packages
RUN wget http://package.mapr.com/releases/v6.1.0/ubuntu/mapr-client-6.1.0.20180926230239.GA-1.amd64.deb; \
    wget http://package.mapr.com/releases/v6.1.0/ubuntu/mapr-librdkafka_0.11.3.201803231414_all.deb; \
    wget http://package.mapr.com/releases/v6.1.0/ubuntu/mapr-posix-client-basic_6.1.0.20180926230239.GA-1_amd64.deb; \
    wget http://package.mapr.com/releases/v6.1.0/ubuntu/mapr-posix-client-platinum_6.1.0.20180926230239.GA-1_amd64.deb; \
    dpkg -i --force-overwrite /tmp/mapr-librdkafka_0.11.3.201803231414_all.deb; \
    dpkg -i --force-overwrite /tmp/mapr-client-6.1.0.20180926230239.GA-1.amd64.deb; \
    dpkg -i --force-overwrite /tmp/mapr-posix-client-basic_6.1.0.20180926230239.GA-1_amd64.deb; \
    dpkg -i --force-overwrite /tmp/mapr-posix-client-platinum_6.1.0.20180926230239.GA-1_amd64.deb; \
    mkdir -p /tmp/lib; \
    mkdir -p /tmp/bin; \
    cp -r /opt/mapr/lib/libfuse.* /tmp/lib; \
    cp -r /opt/mapr/lib/libMapRClient.* /tmp/lib; \
    cp /opt/mapr/server/mruuidgen /tmp/; \
    cp /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so /tmp/lib/libjvm.so; \
    rm -rf /opt/mapr/contrib; \
    rm -rf /opt/mapr/conf; \
    rm -rf /opt/mapr/conf.new; \
    rm -rf /opt/mapr/examples; \
    rm -rf /opt/mapr/hadoop; \
    rm -rf /opt/mapr/initscripts; \
    rm -rf /opt/mapr/include; \
    rm -rf /opt/mapr/libexp; \
    rm -rf /opt/mapr/lib; \
    rm -rf /opt/mapr/logs; \
    rm -rf /opt/mapr/pid; \
    rm -rf /opt/mapr/server; \
    rm -rf /opt/mapr/bin/h*; \
    rm -rf /opt/mapr/bin/m*; \
    mkdir -p /opt/mapr/lib; \
    mkdir -p /opt/mapr/server; \
    cp -r /tmp/lib/* /opt/mapr/lib; \
    cp /tmp/mruuidgen /opt/mapr/server/; \
    rm -rf /tmp

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy utils, driver and set entrypoint
COPY --from=docker.artifactory/maprtech/csi-kdfdriver:1.0.0_002 \
     /go/src/plugin/bin/* /opt/mapr/bin/
RUN chmod +x /opt/mapr/bin/csi-kdfplugin; \
    chmod +x /opt/mapr/bin/start-fuse;
WORKDIR /opt/mapr
ENTRYPOINT ["/tini", "--", "bin/csi-kdfplugin"]