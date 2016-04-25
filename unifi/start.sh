#!/bin/bash

/etc/init.d/cron start
/usr/bin/java -Xmx256M -jar /usr/lib/unifi/lib/ace.jar start
