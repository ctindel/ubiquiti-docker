FROM openjdk:8-jre
MAINTAINER Dan Sully "daniel-github@electricrain.com"

ENV DEBIAN_FRONTEND noninteractive

VOLUME ["/var/lib/unifi"]

# Must be passed in at build time with --build-arg
ARG UNIFI_DEB_URL

# Run the unifi script once to setup symlinks.
# But don't keep any of that data around, as the union mount will replace /var/lib/unifi at runtime.
RUN set -x \
    echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C0A52C50 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    apt-get -q update && \
    apt-get -qy install --no-install-recommends \
        cron \
        curl \
        init-system-helpers \
        jsvc \
        libcommons-daemon-java \
        mongodb-org-shell \
        telnet &&
    curl -L ${UNIFI_DEB_URL} -o /tmp/unifi.deb && \
    dpkg --force-all -i /tmp/unifi.deb || /bin/true && \
    /etc/init.d/unifi start && /etc/init.d/unifi stop && \
    echo "0 2 * * * mongo --host mongo < /bin/mongo_prune_js.js" | crontab && \
    apt-get -qy clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/log/unifi/* /var/lib/unifi/* /usr/lib/unifi/{data.,logs.,run.}*

# Run the MongoDB prune script every day at 2am to minimize DB Stats to last 14 days.
# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-How-to-remove-prune-older-data-and-adjust-mongo-database-size
ADD mongo_prune_js.js /bin
ADD start.sh /bin

# https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used
EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 8881/tcp 8882/tcp

ENV SHELL /bin/bash
CMD []
ENTRYPOINT ["/bin/start.sh"]
