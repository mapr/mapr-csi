# CentOS Package Build
FROM centos:centos8
LABEL mapr.os=centos8
ENV container docker

# Download keys
WORKDIR /tmp
RUN curl --user "<email>:<token>" -o /tmp/maprgpg.key -q https://package.ezmeral.hpe.com/releases/pub/maprgpg.key; \
   curl --user "<email>:<token>" -o /tmp/gnugpg.key -q https://package.ezmeral.hpe.com/releases/pub/gnugpg.key; \
   curl --user "<email>:<token>" -o /tmp/hpeezdf.pub -q https://package.ezmeral.hpe.com/releases/pub/hpeezdf.pub;

# Setup repos and dl prereqs + Mapr Core
COPY mapr.repo /etc/yum.repos.d/
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8; \
    rpm --import /tmp/gnugpg.key; \
    rpm --import /tmp/hpeezdf.pub; \
    rpm --import /tmp/maprgpg.key; \
    rm -rf /tmp/*.key /tmp/*.pub; \
    yum -y update && yum -y clean all; \
    yum -y install epel-release; \
    sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
    sed -i 's/^#baseurl/baseurl/g' /etc/yum.repos.d/CentOS-*; \
    sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/CentOS-*; \
    yum install -y mapr-loopbacknfs; \
    yum clean all && rm -rf /var/cache/yum
    
# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy utils, driver and set entrypoint
COPY --from=maprtech/csi-nfsdriver \
     /go/src/plugin/bin/* /opt/mapr/bin/
RUN chmod +x /opt/mapr/bin/csi-nfsplugin; \
    chmod +x /opt/mapr/bin/start-loopbacknfs;
WORKDIR /opt/mapr
ENTRYPOINT ["/tini", "--", "bin/csi-nfsplugin"]
