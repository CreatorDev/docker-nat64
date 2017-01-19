.PHONY: all
all: image

TAYGA_VERSION:=0.9.2
TAYGA:=tayga-$(TAYGA_VERSION)
TAYGA_TARBALL:=tayga-$(TAYGA_VERSION).tar.bz2

TOTD_VERSION:=1.5.3
TOTD:=totd-$(TOTD_VERSION)
TOTD_TARBALL:=totd-$(TOTD_VERSION).tar.gz

image: $(TAYGA) $(TOTD)

$(TAYGA): dl/$(TAYGA_TARBALL)
	tar xmf $<

$(TOTD): dl/$(TOTD_TARBALL)
	tar xmf $<

dl/$(TAYGA_TARBALL): | dl
	wget -O$@ http://www.litech.org/tayga/$(TAYGA_TARBALL)

dl/$(TOTD_TARBALL): | dl
	wget -O$@ https://github.com/fwdillema/totd/archive/$(TOTD_VERSION).tar.gz

dl:
	mkdir $@

DOCKER_ORGANISATION:=creatordev
DOCKER_SHELL:=ash
CONTAINER_NAME:=docker-nat64
# DOCKER_BUILDARG_BUILDDATE:=
include ../docker.mk
