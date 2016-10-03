FROM phusion/baseimage:0.9.18
MAINTAINER Chad Tindel "chad@tindel.net"

# Must be passed in at build time with --build-arg
ARG UNIFI_VIDEO_VERSION
ARG UNIFI_VIDEO_DEB_URL

# We are installing mongodb 3.2 here so that the wiredtiger storage
#  engine will get used by default.  Unifi Video starts mongod with 
#  the --smallfiles option, which is a config that is only relevant 
#  for mmapv1 storage engine.  We end up with a log that says 
#  "Detected configuration for non-active storage engine mmapv1 when 
#  current storage engine is wiredTiger" but it seems to be harmless.  
#  Still, would be nice to be able to override the mongod options.
#
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-get update && apt-get install -y mongodb-org && \
    curl -L ${UNIFI_VIDEO_DEB_URL} -o /tmp/unifi-video.deb && \
    mkdir -p /var/cache/unifi-video && \
    mkdir -p /var/run/unifi-video && \
    dpkg -i /tmp/unifi-video.deb || /bin/true && apt-get -yf --force-yes install && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i.bak 's/ulimit -H -c 200//g' /usr/sbin/unifi-video && \
	chmod 755 /usr/sbin/unifi-video

ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

# No reason to expose the MongoDB port 7441 to the outside for most people
EXPOSE 1935 6666 7080 7443 7445 7446 7447 
#EXPOSE 7441

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/bin/start.sh"]
