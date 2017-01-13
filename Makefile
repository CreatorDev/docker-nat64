.PHONY: all
all: image

.PHONY: run
run: image
	docker-compose up -d

DOCKER_ORGANISATION:=creatordev
DOCKER_SHELL:=ash
# DOCKER_BUILDARG_BUILDDATE:=
include docker.mk