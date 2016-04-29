Docker image ctindel/unifi-video-controller is a Docker images to 
run the Unifi Video Controller a Synology NAS.  The image requires
you to run the container with a number of extra capabilities, as 
well as disabling apparmor for the container and mounting a host
volume to store all your configuration, videos, and mongodb database
files into the /var/lib/unifi-video location on the container.

The Synology Docker UI doesn't provide the ability to set these
more esoteric security policies, so if you want to start it from there
you will need to select "privileged" mode for the container.

Alternately, if you prefer to have a more reduced security
profile you can run it from the command line.  Here's an example
from my system, you'll probably need to change the directory for
the host volume mount:

```
docker run --restart always --name unifi-video-controller -p 1935:1935 -p 6666:6666 -p 7080:7080 -p 7443:7443 -p 7445:7445 -p 7446:7446 -p 7447:7447 -d -v /volume3/docker/unifi-video-controller:/var/lib/unifi-video --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH --cap-add=NET_BIND_SERVICE --cap-add=SYS_PTRACE --cap-add=SETUID --cap-add=SETGID --security-opt apparmor:unconfined ctindel/unifi-video-controller:3.1.5
```

If you feel like building the container for yourself, here's
how I do it:

```
docker build --no-cache --build-arg UNIFI_VIDEO_VERSION=3.1.5 --build-arg UNIFI_VIDEO_DEB_URL=http://dl.ubnt.com/firmwares/unifi-video/3.1.5/unifi-video_3.1.5~Ubuntu14.04_amd64.deb -t ctindel/unifi-video-controller:3.1.5 --rm .
```
