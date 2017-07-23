USER = kairen
IMAGES := \
  dnsmasq disk-image-build tftp boot-image httpd \
	ironic-base ironic-api ironic-conductor ironic-dbsync ironic-test

BUILD = echo -e "\033[34m*** Build $(1) image ***\033[0m"; \
	docker build -t $(USER)/$(1) $(1)/.

DELETE = echo -e "\033[34m*** Delete $(1) image ***\033[0m"; \
	docker stop $(1); docker rm $(1)

.PHONY: all build install uninstall dib devel

all: build

build:
	for image in $(IMAGES); do $(call BUILD,$$image); done

install:
	./.run.sh

OVI = $(IMAGES)
override OVI += rabbitmq mariadb
uninstall:
	for image in $(OVI); do $(call DELETE,$$image); done

dib:
	docker run -it --rm --name disk-image-build \
		-v image:/imagedata \
		-v /root/.ssh/id_rsa.pub:/id_rsa.pub \
		-v /dev/:/dev/ \
		--privileged \
		$(USER)/disk-image-build

devel:
	docker run -it \
		--env-file ./config \
		--name ironic-test \
		--link=rabbitmq:rabbitmq \
		--link=mariadb:mariadb \
		--entrypoint=/bin/bash \
		--rm \
		$(USER)/ironic-test
