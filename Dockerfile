FROM debian:7.10
MAINTAINER Chad Tindel "chad@tindel.net"

# Must be passed in at build time with --build-arg
ARG UNIFI_VERSION

# apt-get update && apt-get -y install unifi && \
# OR
# RUN curl http://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb -o /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb
# RUN dpkg -i /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb || /bin/true && apt-get -yf --force-yes install

# We download the exact version of Unifi that we want so that we know our 
#  docker tags are correct instead of apt-get update && apt-get -y install unifi
#
# We need to run the unifi script once because it sets up all the 
#  /var/lib/unifi and /usr/lib/unifi symlinks for us.  But we don't
#  want to keep any of that data around, we want our union mount to
#  replace /var/lib/unifi so we remove a bunch of dirs at the end
#RUN apt-get update && apt-get install -y curl cron procps net-tools vim && \
RUN apt-get update && apt-get install -y curl cron && \
    echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/100-ubnt.list && \
    apt-get -y install debian-keyring debian-archive-keyring && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C0A52C50 && \
    gpg --export C0A52C50 | apt-key add - && \
	curl http://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb -o /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb && \
	dpkg -i /tmp/unifi_sysvinit_all-${UNIFI_VERSION}.deb || /bin/true && apt-get -yf --force-yes install && \
	crontab -l | { cat; echo "0 2 * * * mongo --port 27117 < /mongo_prune_js.js"; } | crontab - && \
    /etc/init.d/unifi start && /etc/init.d/unifi stop && \ 
    dpkg --purge curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm -rf /var/lib/unifi/* /usr/lib/unifi/{data.,logs.,run.}* 

# We'll run the mongo prune script every day at 2am to minimize
#  DB Stats to last 14 days.  See crontab addition above
# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-How-to-remove-prune-older-data-and-adjust-mongo-database-size

ADD mongo_prune_js.js /

# No reason to expose the MongoDB port 27117 to the outside for most people
EXPOSE 8080 8443 8843 8880
#EXPOSE 27117

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/usr/bin/java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
