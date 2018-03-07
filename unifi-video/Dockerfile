FROM phusion/baseimage:0.9.22
MAINTAINER Chad Tindel "chad@tindel.net"

# Must be passed in at build time with --build-arg
ARG UNIFI_VIDEO_VERSION
ARG UNIFI_VIDEO_DEB_URL

# We are installing mongodb 3.4 here so that the wiredtiger storage
#  engine will get used by default.  Unifi Video starts mongod with 
#  the --smallfiles option, which is a config that is only relevant 
#  for mmapv1 storage engine.  We end up with a log that says 
#  "Detected configuration for non-active storage engine mmapv1 when 
#  current storage engine is wiredTiger" but it seems to be harmless.  
#  Still, would be nice to be able to override the mongod options.
#
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && apt-get install -y mongodb-org tzdata && \
    curl -L ${UNIFI_VIDEO_DEB_URL} -o /tmp/unifi-video.deb && \
    mkdir -p /var/cache/unifi-video && \
    mkdir -p /var/run/unifi-video && \
    dpkg -i /tmp/unifi-video.deb || /bin/true && apt-get -yf --force-yes install && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i.bak 's/ulimit -H -c 200//g' /usr/sbin/unifi-video && \
    chmod 755 /usr/sbin/unifi-video && \
	mkdir -p /usr/lib/unifi-video/certificates
    #sed -i.bak 's/PKGUSER=unifi-video/PKGUSER=root/g' /usr/sbin/unifi-video && \
    #chown -R unifi-video:unifi-video /var/lib/unifi-video /usr/lib/unifi-video /var/log/unifi-video && \
	#chwon -R root:root /var/log/unifi-video

ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

# No reason to expose the MongoDB port 7441 to the outside for most people
EXPOSE 1935 6666 7080 7443 7445 7446 7447 
#EXPOSE 7441

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/bin/start.sh"]
