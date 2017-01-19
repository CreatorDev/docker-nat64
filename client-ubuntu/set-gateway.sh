#!/bin/sh

ip route del default
ip route add default via $IPV4_GATEWAY dev eth0
ip -6 route del default
ip -6 route add default via $IPV6_GATEWAY dev eth0

echo "nameserver $IPV6_GATEWAY" > /etc/resolv.conf

echo "invoking [$@]"
exec "$@"