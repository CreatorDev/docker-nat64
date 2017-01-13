#!/bin/sh

ip route del default
ip route add default via $1 dev eth0
shift 1

exec "$@"