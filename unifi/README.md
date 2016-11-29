This Docker image contains the Ubiquiti Unifi Controller, using an external MongoDB container.

Quick Start:

  docker run -d --name mongo mongo:3
  docker run -d --name unifi-controller \
     -p 8080:8080 \
     -p 8443:8443 \
     -p 8843:8843 \
     -p 8880:8880 \
     --link mongo:mongo \
     --volume /tmp/unifi:/var/lib/unifi \
     dsully/unifi-controller:latest
