FROM debian:7.10
MAINTAINER Chad Tindel "chad@tindel.net"

ENV UNIFI_VERSION 4.8.15

RUN apt-get update && apt-get install -y curl procps net-tools vim && \
    echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/100-ubnt.list && \
    apt-get -y install debian-keyring debian-archive-keyring && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C0A52C50 && \
    gpg --export C0A52C50 | apt-key add - && \
    apt-get update && apt-get -y install unifi && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN curl http://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb -o /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb
#RUN dpkg -i /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb || /bin/true && apt-get -yf install


ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

EXPOSE 8080 8443 8843 8880
#EXPOSE 27117

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/bin/start.sh"]
