FROM alpine

RUN mkdir -p /build && \
	apk update && \
	apk add \
		gcc \
		musl-dev \
		linux-headers \
		make \
		net-tools \
		iptables

# add this to get messages from tayga and totd into /var/log/messages
#RUN apk add rsyslog

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

# we could make things a lot smaller, still got a bunch of layers at the moment
RUN rm -rf /build && \
	apk del \
		gcc \
		musl-dev \
		linux-headers \
		make

# beware .. totd.conf should match TAYGA_CONF_PREFIX
ENV \
	TAYGA_CONF_DATA_DIR=/var/db/tayga \
	TAYGA_CONF_IPV4_ADDR=172.30.1.1 \
	TAYGA_CONF_DYNAMIC_POOL=172.28.1.0/24 \
	TAYGA_CONF_PREFIX=fd9d:aa38:64::/96 \
	TAYGA_ROUTER_IPV4=172.28.0.254 \
	TAYGA_ROUTER_IPV6=fd9d:aa38:64::1/64 \
	CLIENT1_TAP_PREFIX=fdfd::/64 \
	CLIENT1_IPV6=fd30:252e:b4f5:0:1::2

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
