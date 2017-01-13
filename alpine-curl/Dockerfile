FROM alpine
ADD set-gateway.sh /
RUN \
	apk update && \
	apk add curl net-tools tcpdump iptables && \
	chmod +x /set-gateway.sh
