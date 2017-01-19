.PHONY: all
all: nat64 client-ubuntu compose-build

.PHONY: run
run: all
	docker-compose up -d

.PHONY: nat64 client-ubuntu
nat64 client-ubuntu:
	$(MAKE) -C $@ image

.PHONY: docker-clean docker-exec
docker-clean docker-exec:
	$(MAKE) -C nat64 $@

docker-exec: run

.PHONY: compose-build
compose-build:
	docker-compose build
