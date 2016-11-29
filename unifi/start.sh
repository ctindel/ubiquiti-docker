#!/bin/bash

/etc/init.d/cron start

rm -f /var/run/unifi/unifi.pid

echo "Starting Unifi Controller.."

# Tell the Unifi controller to talk to the external MongoDB container.
echo "db.mongo.local=false" >> /var/lib/unifi/system.properties
echo "db.mongo.uri=mongodb\://mongo\:27017/unifi" >> /var/lib/unifi/system.properties
echo "statdb.mongo.uri=mongodb\://mongo\:27017/unifi_stat" >> /var/lib/unifi/system.properties
echo "unifi.db.name=unifi" >> /var/lib/unifi/system.properties

exec /usr/bin/jsvc \
 -nodetach \
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
