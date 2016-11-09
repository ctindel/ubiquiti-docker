NAME = dsully/unifi-controller
VERSION = 5.4.2
HASH="-07b1a63c"
UNIFI_DEB_URL=https://www.ubnt.com/downloads/unifi/$(VERSION)$(HASH)/unifi_sysvinit_all.deb

.PHONY: all build test tag_latest release

all: build

build:
	docker build --build-arg UNIFI_DEB_URL=$(UNIFI_DEB_URL) -t $(NAME):$(VERSION) --rm .

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./mock_test.sh

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
