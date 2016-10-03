#!/bin/bash

/etc/init.d/cron start

rm -f /var/run/unifi/unifi.pid

/usr/bin/jsvc \
 -nodetach \
 -debug \
 -home /usr/lib/jvm/java-8-openjdk-amd64 \
 -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar \
 -pidfile /var/run/unifi/unifi.pid \
 -procname unifi \
 -Dunifi.datadir=/var/lib/unifi \
 -Dunifi.logdir=/var/log/unifi \
 -Dunifi.rundir=/var/run/unifi \
 -Xmx1024M \
 -Dfile.encoding=UTF-8 \
 com.ubnt.ace.Launcher start
