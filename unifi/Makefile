NAME = ctindel/unifi-controller
VERSION = 4.9.1-alpha-691f5a97

.PHONY: all build test tag_latest release

all: build

build:
	docker build --no-cache --build-arg UNIFI_VERSION=$(VERSION) -t $(NAME):$(VERSION) --rm .

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./mocktest.sh

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
