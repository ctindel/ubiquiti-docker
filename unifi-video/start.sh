#!/bin/bash -x

# This system.properties file would normally be laid down by the debian package
# installer, but as we expect the user to overlay an external volume onto
# /var/lib/unifi-video it will be empty on first container start so we need
# to fill it in ourselves.
if [ ! -f /var/lib/unifi-video/system.properties ]; then
    echo "is_default=true" > /var/lib/unifi-video/system.properties
fi

# We don't want the process to daemonize because we want it to run forever as the docker container process
echo "UFV_DAEMONIZE=false" > /etc/default/unifi-video

/usr/sbin/unifi-video start
