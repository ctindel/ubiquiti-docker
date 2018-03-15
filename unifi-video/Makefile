NAME=ctindel/unifi-video-controller
VERSION=3.9.4
UNIFI_VIDEO_DEB_URL=http://dl.ubnt.com/firmwares/ufv/v$(VERSION)/unifi-video.Ubuntu16.04_amd64.v$(VERSION).deb

.PHONY: all build test tag_latest release

all: build

build:
	docker build --no-cache --build-arg UNIFI_VIDEO_VERSION=$(VERSION) --build-arg UNIFI_VIDEO_DEB_URL=$(UNIFI_VIDEO_DEB_URL) -t $(NAME):$(VERSION) --rm=true .

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./mock_test.sh

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
