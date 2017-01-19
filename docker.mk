#
#  Input variables
#
#  - DISABLE_DOCKER
#
#  - DOCKERFILE
#
#  - DOCKER_REGISTRY
#  - DOCKER_ORGANISATION
#  - CONTAINER_NAME
#  - IMAGE_VERSION
#
#  - DOCKER_SHELL
#  - BIND_VOLUMES
#  - EXPOSE_PORTS
#  - EXTRA_RUN_OPTS
#

GIT_COMMIT:=$(strip $(shell git rev-parse --short HEAD 2>/dev/null))
GIT_ORIGIN_URL:=$(shell git config --get remote.origin.url 2>/dev/null)
GIT_TAG:=$(shell git describe --tags 2> /dev/null)
GIT_TAG_VSTRIPPED:=$(patsubst v%,%,$(GIT_TAG))

IMAGE_VERSION_DEFAULT?=latest

ifndef IMAGE_VERSION
ifneq ("$(GIT_TAG_VSTRIPPED)_","_")
IMAGE_VERSION:=$(GIT_TAG_VSTRIPPED)
else
IMAGE_VERSION:=$(IMAGE_VERSION_DEFAULT)
endif
endif

ifndef DOCKER_SHELL
DOCKER_SHELL:=/bin/bash
endif

ifndef CONTAINER_NAME
DIR_NAME:=$(notdir $(realpath .))
#CONTAINER_NAME:=$(subst -,,$(DIR_NAME))
CONTAINER_NAME:=$(DIR_NAME)
endif

#
#  build up the IMAGE_NAME, optionally including REGISTRY and ORGANISATION
#
IMAGE_NAME:=$(CONTAINER_NAME):$(IMAGE_VERSION)
ifneq ("$(DOCKER_ORGANISATION)x","x")
IMAGE_NAME:=$(DOCKER_ORGANISATION)/$(IMAGE_NAME)
endif
ifneq ("$(DOCKER_REGISTRY)x","x")
IMAGE_NAME:=$(DOCKER_REGISTRY)/$(IMAGE_NAME)
endif

#
# also build image:latest
#
IMAGE_DEFAULT:=$(patsubst %:$(IMAGE_VERSION),%:$(IMAGE_VERSION_DEFAULT),$(IMAGE_NAME))

ifeq ($(DOCKERFILE)x,x)
DOCKERFILE:=$(wildcard Dockerfile)
endif
ifneq ($(DOCKERFILE)x,x)
ifndef EXPOSE_PORTS
EXPOSE_PORTS:=$(shell gawk '/^EXPOSE/ { for(i=2;i<=NF;i++) printf("-p %s:%s ", $$i, $$i) }' Dockerfile)
endif
endif

ifndef BIND_VOLUMES
BIND_VOLUMES:=
endif

ifeq ($(origin DOCKER_BUILDARG_VCSREF),undefined)
DOCKER_VCSREF?=$(GIT_COMMIT)
ifeq ($(DOCKER_VCSREF)x,x)
DOCKER_VCSREF:=unknown
endif
DOCKER_BUILDARG_VCSREF:=--build-arg "VCS_REF=$(DOCKER_VCSREF)"
endif

ifeq ($(origin DOCKER_BUILDARG_VCSURL),undefined)
DOCKER_VCSURL?=$(GIT_ORIGIN_URL)
ifeq ($(DOCKER_VCSURL)x,x)
DOCKER_VCSURL:=unknown
endif
DOCKER_BUILDARG_VCSURL:=--build-arg "VCS_URL=$(DOCKER_VCSURL)"
endif

ifeq ($(origin DOCKER_BUILDARG_BUILDDATE),undefined)
DOCKER_BUILDARG_BUILDDATE:=--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
endif

.PHONY: image
image:
	$(call PROMPT,docker build)
	rm -f $(TAR_FILE)
	docker build --rm --force-rm \
		-t $(IMAGE_DEFAULT) \
		-f $(DOCKERFILE) \
		$(DOCKER_BUILDARG_VCSREF) \
		$(DOCKER_BUILDARG_VCSURL) \
		$(DOCKER_BUILDARG_BUILDDATE) \
		.
	[ "$(IMAGE_VERSION)" == "$(IMAGE_VERSION_DEFAULT)" ] || docker tag $(IMAGE_DEFAULT) $(IMAGE_NAME)

.PHONY: clean
clean::
	rm -f $(TAR_FILE)
	-docker kill $(CONTAINER_NAME) 2> /dev/null
	-docker rm $(CONTAINER_NAME) 2> /dev/null

.PHONY: clobber
clobber:: clean
	-docker rmi -f $(IMAGE_NAME) $(IMAGE_DEFAULT) 2> /dev/null

TAR_FILE:=$(notdir $(subst :,_,$(IMAGE_NAME))).tar

.PHONY: docker-tar
docker-tar:
	$(call PROMPT,docker save)
	docker save '$(IMAGE_NAME)' > $(TAR_FILE)
	gzip $(TAR_FILE)

#
# Push both the versioned and the default "latest" image. They might be the same thing - but,
# if so, then the second one will complete very quickly.
#
.PHONY: docker-push
docker-push:
	$(call PROMPT,docker push)
	docker push $(IMAGE_NAME)
	docker push $(IMAGE_DEFAULT)

.PHONY: docker-run
docker-run: clean
	docker run -d $(EXTRA_RUN_OPTS) $(EXPOSE_PORTS) $(BIND_VOLUMES) --name $(CONTAINER_NAME) $(IMAGE_NAME)

.PHONY: docker-exec
docker-exec:
	docker exec -ti $(CONTAINER_NAME) $(DOCKER_SHELL)

.PHONY: docker-entry
docker-entry:
	docker run -ti $(EXTRA_RUN_OPTS) $(EXPOSE_PORTS) $(BIND_VOLUMES) --entrypoint $(DOCKER_SHELL) $(IMAGE_NAME)

# Useful with a scratch container. Use in Dockerfile as:
#
#   ADD ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt
ca-bundle.crt:
	curl -sL https://mkcert.org/generate/ > $@

#
#  Clean up general docker environment
#
.PHONY: docker-clean
docker-clean:
	docker images | grep '<none>' | gawk '{ print $$3 }' | xargs docker rmi
