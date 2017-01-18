.PHONY: all
all: image compose-build

.PHONY: run
run: image
	docker-compose up -d

image docker-clean:
	$(MAKE) -C nat64 $@

.PHONY: compose-build
compose-build:
	docker-compose build
