# Copyright (c) 2009 & onwards. MapR Tech, Inc., All rights reserved

# CentOS Package Build
FROM centos:centos7
LABEL mapr.os=centos7
ENV container docker
# Setup repos and dl prereqs + Mapr Core
COPY mapr.repo /etc/yum.repos.d/
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7; \
    rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7; \
    rpm --import https://package.mapr.com/releases/pub/maprgpg.key; \
    rpm --import https://package.mapr.com/releases/pub/gnugpg.key; \
    yum -y update && yum -y clean all; \
    yum -y install epel-release; \
    sed -i 's/^mirror/#mirror/g' /etc/yum.repos.d/epel.repo; \
    sed -i 's/^#base/base/g' /etc/yum.repos.d/epel.repo; \
    yum install -y java-1.8.0-openjdk-devel mapr-posix-client-basic mapr-posix-client-platinum && \
    yum clean all && rm -rf /var/cache/yum; \
    cp /usr/lib/jvm/jre/lib/amd64/server/libjvm.so /opt/mapr/lib/libjvm.so

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy utils, driver and set entrypoint
COPY --from=docker.artifactory/maprtech/csi-kdfdriver:1.0.0_003 \
     /go/src/plugin/bin/* /opt/mapr/bin/
RUN chmod +x /opt/mapr/bin/csi-kdfplugin; \
    chmod +x /opt/mapr/bin/start-fuse;
WORKDIR /opt/mapr
ENTRYPOINT ["/tini", "--", "bin/csi-kdfplugin"]