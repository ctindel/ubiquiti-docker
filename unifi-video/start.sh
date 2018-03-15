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

# check for presence of perms file, if it exists then skip setting
# permissions, otherwise recursively set on volume mappings for host
if [[ ! -f "/var/lib/unifi-video/perms.txt" ]]; then
    echo "About to run 'chown -R unifi-video:unifi-video /var/lib/unifi-video' this could take a while..."
    chown -R unifi-video:unifi-video /var/lib/unifi-video

    echo "This file prevents permissions from being applied/re-applied to /config, if you want to reset permissions then please delete this file and restart the container." > /var/lib/unifi-video/perms.txt || exit 1
	chown unifi-video:unifi-video /var/lib/unifi-video/perms.txt || exit 1
else
    echo "Ownership permissions already set, no need to chown again"
fi

mkdir -p /var/lib/unifi-video/logs
chown -R unifi-video:unifi-video /var/lib/unifi-video/logs

#sed -i.bak 's/PKGUSER=.*/PKGUSER=root/g' /usr/sbin/unifi-video

#while true
#do
#    echo "Press [CTRL+C] to stop.."
#    sleep 1
#done
/usr/sbin/unifi-video --nodetach --debug --verbose start
