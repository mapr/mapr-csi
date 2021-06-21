# Copyright (c) 2009 & onwards. MapR Tech, Inc., All rights reserved
# CentOS Package Build
FROM centos:centos8
LABEL mapr.os=centos8
ENV container docker

# Setup repos and dl prereqs + Mapr Core
COPY mapr.repo /etc/yum.repos.d/
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8; \
   rpm --import https://package.mapr.com/releases/pub/maprgpg.key; \
   rpm --import https://package.mapr.com/releases/pub/gnugpg.key; \
   yum -y update && yum -y clean all; \
   yum -y install epel-release; \
   sed -i 's/^mirror/#mirror/g' /etc/yum.repos.d/epel.repo; \
   yum install -y mapr-client mapr-posix-client-basic mapr-posix-client-platinum && \
   yum -y update && yum clean all && rm -rf /var/cache/yum; \
   mkdir -p /opt/mapr/lib/fusebasic /opt/mapr/lib/fuseplatinum; \
   cp /opt/mapr/lib/libMapRClient_c.so.1 /opt/mapr/lib/fusebasic/libMapRClient_c.so.0; \
   rm -rf /opt/mapr/lib/libMapRClient_c.so.1

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy utils, driver and set entrypoint
COPY --from=maprtech/csi-kdfdriver \
    /go/src/plugin/bin/* /opt/mapr/bin/
RUN chmod +x /opt/mapr/bin/csi-kdfplugin; \
   chmod +x /opt/mapr/bin/start-fuse;
WORKDIR /opt/mapr
ENTRYPOINT ["/tini", "--", "bin/csi-kdfplugin"]
