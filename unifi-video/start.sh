#!/bin/bash

# I had a previous incarnation which would install the debian package on first
#  container boot instead of during image building so that we could use the init
#  script instead of running jsvc manually.  The init script needs to do things
#  like mounting a tmpfs which requires various security capabilities and 
#  unconfined apparmor, so it could not be done at image build time 
#  (https://github.com/docker/docker/issues/1916).  But if we recreate all the 
#  startup tasks from the init script here instead, then we can get away without
#  using it, and we'll be able to install the debian package at image build
#  time instead. I'm leaving the code here below commented out in case for some 
#  reason I need we to use it again
#
# The first time we boot, the deb file will have been downloaded to /tmp/unifi-video.deb
#  but we need to install it after the container boots the first time 
#  so the configuration files can be written to the external 
#  /usr/lib/unifi-video/conf directory
#PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unifi-video|grep "install ok installed")
#echo "Checking if unifi-video is installed: $PKG_OK"
#if [ "" == "$PKG_OK" ]; then
#  dpkg -i /tmp/unifi-video.deb || /bin/true && apt-get -yf --force-yes install
#fi

# This system.properties file would normally be laid down by the debian package
#  installer, but as we expect the user to overlay an external volume onto 
#  /var/lib/unifi-video it will be empty on first container start so we need
#  to fill it in ourselves.
if [ ! -f /var/lib/unifi-video/system.properties ]; then
    echo "is_default=true" > /var/lib/unifi-video/system.properties
fi

# We don't want the process to daemonize because we want it to run forever
#  as the docker container process
echo "UFV_DAEMONIZE=false" > /etc/default/unifi-video
/usr/sbin/unifi-video start
