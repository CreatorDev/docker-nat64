.PHONY: all
all: image compose-build

.PHONY: run
run: all
	docker-compose up -d

docker-exec: run

image docker-clean docker-exec:
	$(MAKE) -C nat64 $@

.PHONY: compose-build
compose-build:
	docker-compose build
