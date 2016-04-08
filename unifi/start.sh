#!/bin/bash

/etc/init.d/unifi start

tail -F /var/log/unifi/server.log
