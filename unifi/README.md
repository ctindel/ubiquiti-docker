This Docker image contains the Ubiquiti Unifi Controller, using an external MongoDB container.

Originally meant for running on a Synology, it can be run anywhere.

Requirements:

* docker
* docker-compose 1.6+

Quick Start:

```
  $ mkdir -p /volume1/docker/
  $ curl -sO https://raw.githubusercontent.com/dsully/ubiquiti-docker/master/unifi/docker-compose.yml
  $ docker-compose up -d
```