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

ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url=$VCS_URL
