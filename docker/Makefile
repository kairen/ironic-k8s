USER = kairen
IMAGES := ironic
BUILD = echo -e "\033[34m*** Build $(1) ***\033[0m"; \
	docker build -t $(USER)/$(1) $(1)/.

DELETE = echo -e "\033[34m*** Delete $(1) image ***\033[0m"; \
	docker stop $(1); docker rm $(1)

.PHONY: all build deploy reset dib devel

all: build

build:
	for image in $(IMAGES); do $(call BUILD,$$image); done
	cd general; ./.build.sh

deploy:
	./.run.sh

RPN := tftp httpd dnsmasq ironic-api ironic-conductor mariadb rabbitmq
reset:
	for name in $(RPN); do $(call DELETE,$$name); done

dib:
	docker run -it --rm \
		-v image:/imagedata \
		-v /root/.ssh/id_rsa.pub:/id_rsa.pub \
		-v /dev/:/dev/ \
		--privileged \
		$(USER)/disk-image-build

devel:
	docker run -it --rm \
		--env-file ./config.env \
		--link=rabbitmq:rabbitmq \
		--link=mariadb:mariadb \
		$(USER)/ironic devel
