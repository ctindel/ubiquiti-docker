FROM phusion/baseimage:0.9.22
MAINTAINER Chad Tindel "chad@tindel.net"

# Must be passed in at build time with --build-arg
ARG UNIFI_VERSION
ARG UNIFI_DEB_URL

# We'll run the mongo prune script every day at 2am to minimize
#  DB Stats to last 14 days.  See crontab addition above
# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-How-to-remove-prune-older-data-and-adjust-mongo-database-size

ADD mongo_prune_js.js /bin
ADD start.sh /bin
RUN /bin/chmod +x /bin/start.sh

# We download the exact version of Unifi that we want so that we know our 
#  docker tags are correct instead of apt-get update && apt-get -y install unifi
#
# We need to run the unifi script once because it sets up all the 
#  /var/lib/unifi and /usr/lib/unifi symlinks for us.  But we don't
#  want to keep any of that data around, we want our union mount to
#  replace /var/lib/unifi so we remove a bunch of dirs at the end
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv C0A52C50 && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
	echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/100-ubnt.list && \
    apt-get update && apt-get install -y mongodb-org tzdata && \
    apt-get install -y curl cron procps net-tools vim mongodb-org && \
    curl -L ${UNIFI_DEB_URL} -o /tmp/unifi.deb && \
    dpkg -i /tmp/unifi.deb || /bin/true && apt-get -yf --force-yes install && \
    crontab -l | { cat; echo "0 2 * * * mongo --port 27117 < /bin/mongo_prune_js.js"; } | crontab - && \
    /etc/init.d/unifi start && /etc/init.d/unifi stop && \ 
    dpkg --purge curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/lib/unifi/* /usr/lib/unifi/{data.,logs.,run.}* 

# No reason to expose the MongoDB port 27117 to the outside for most people
EXPOSE 8080 8443 8843 8880
#EXPOSE 27117

ENV SHELL /bin/bash

CMD []
ENTRYPOINT ["/bin/start.sh"]
