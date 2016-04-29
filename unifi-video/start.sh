#!/bin/bash

# The tmpfs mount would normally be done by the /etc/init.d/unifi-video script
# This is just what the JSVC line in /etc/init.d/unifi-video expands to
#  except I've added the -debug here just to get more logging and the -nodetach
#  so we stay in the foreground
# We dont run jsvc with -user unifi-video because it needs to run as root to
#  write to the host mounted volume
if [ ! -f /var/lib/unifi-video ]; then
    echo "is_default=true" > /var/lib/unifi-video/system.properties
fi

mount -t tmpfs -o noatime,nodiratime,noexec,size=512m,mode=0777,uid=104 tmpfs /var/cache/unifi-video && \
rm -f /var/run/unifi-video/unifi-video.pid && \
/usr/bin/jsvc -debug \
  -nodetach \
  -cwd /usr/lib/unifi-video \
  -home /usr/lib/jvm/java-7-openjdk-amd64/jre \
  -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar \
  -pidfile /var/run/unifi-video/unifi-video.pid \
  -procname unifi-video \
  -Dav.tempdir=/var/cache/unifi-video \
  -Djava.security.egd=file:/dev/./urandom \
  -Djava.awt.headless=true \
  -Dfile.encoding=UTF-8 \
  -Xmx1024M com.ubnt.airvision.Main start
