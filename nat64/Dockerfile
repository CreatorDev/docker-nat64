FROM alpine

RUN mkdir -p /build && \
	apk update && \
	apk add \
		abuild \
		binutils \
		build-base \
		gcc \
		linux-headers \
		make \
		net-tools \
		iptables \
		rsyslog

ADD tayga-0.9.2 /build/tayga-0.9.2
RUN cd /build/tayga-0.9.2 && \
	./configure --prefix=/usr && \
	make && \
	make install

ADD totd-1.5.3 /build/totd-1.5.3
ADD files/totd.conf /etc
RUN cd /build/totd-1.5.3 && \
	./configure --prefix=/usr && \
	make && \
	mkdir -p /usr/man/man8 && \
	make install

ENV \
	TAYGA_CONF_IPV4_ADDR=192.168.255.1 \
	TAYGA_CONF_DYNAMIC_POOL=192.168.255.0/24 \
	TAYGA_ROUTER_IPV4=192.168.0.1 \
	TAYGA_CONF_PREFIX=fd30:252e:b4f5:ffff::/96 \
	TAYGA_ROUTER_IPV6=fd30:252e:b4f5::1 \
	TAYGA_CONF_DATA_DIR=/var/db/tayga

ADD files/docker-entry.sh /
RUN chmod +x /docker-entry.sh

ENTRYPOINT ["/docker-entry.sh"]
CMD ["ash"]

ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url=$VCS_URL
