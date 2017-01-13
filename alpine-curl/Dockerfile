FROM alpine
ADD set-gateway.sh /
RUN \
	apk update && \
	apk add curl net-tools && \
	chmod +x /set-gateway.sh
