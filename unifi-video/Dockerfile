FROM buildpack-deps:sid-curl
MAINTAINER Dan Sully "daniel-github@electricrain.com"

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://www.ubnt.com/downloads/unifi-video/apt-3.x xenial ubiquiti" >> /etc/apt/sources.list
RUN apt-get -y update && apt-get --allow-unauthenticated -y install binutils procps vim-tiny unifi-video
RUN apt-get -qy clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p /var/cache/unifi-video && mkdir -p /var/run/unifi-video
RUN sed -i.bak 's/ulimit -H -c 200//g' /usr/sbin/unifi-video
RUN sed -i.bak 's/PKGUSER=unifi-video/PKGUSER=root/g' /usr/sbin/unifi-video
RUN sed -i.bak 's/ENABLE_TMPFS=yes/ENABLE_TMPFS=no/g' /usr/sbin/unifi-video
RUN chmod 755 /usr/sbin/unifi-video && chown -R root.root /var/lib/unifi-video /usr/lib/unifi-video /var/log/unifi-video

ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

# https://help.ubnt.com/hc/en-us/articles/217875218-UniFi-Video-Ports-Used
EXPOSE 6666 7080/tcp 7443/tcp 7445/tcp 7446/tcp 7447

VOLUME ["/var/lib/unifi-video", "/var/log/unifi-video", "/usr/lib/unifi-video/work"]

WORKDIR /usr/lib/unifi-video

ENV SHELL /bin/bash
CMD ["/bin/start.sh"]
