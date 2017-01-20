FROM creatordev/system-test-base
USER root

ADD set-gateway.sh /
ENTRYPOINT ["/set-gateway.sh"]
CMD ["bash"]

RUN apt-get update \
	&& apt-get install -yq \
		curl \
		iptables \
		iputils-ping \
		net-tools \
		tcpdump \
	&& chmod +x /set-gateway.sh

# This is passed to Contiki minimal-net HARD_CODED_ADDRESS
# See https://github.com/contiki-os/contiki/blob/master/platform/minimal-net/contiki-conf.h
ENV \
	TAP_PREFIX=fdfd:: \
	IPV4_GATEWAY=172.29.0.2 \
	IPV6_GATEWAY=fd30:252e:b4f5:0:1::1

ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url=$VCS_URL
