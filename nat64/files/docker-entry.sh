#!/bin/sh

rsyslogd
mkdir -p /var/db/tayga

cat >/usr/etc/tayga.conf <<EOD
tun-device nat64
ipv4-addr $TAYGA_CONF_IPV4_ADDR
prefix $TAYGA_CONF_PREFIX
dynamic-pool $TAYGA_CONF_DYNAMIC_POOL
data-dir $TAYGA_CONF_DATA_DIR
EOD

tayga -c /usr/etc/tayga.conf --mktun
ip link set nat64 up
ip addr add $TAYGA_ROUTER_IPV4 dev nat64
ip addr add $TAYGA_ROUTER_IPV6 dev nat64
ip route add $TAYGA_CONF_DYNAMIC_POOL dev nat64
ip route add $TAYGA_CONF_PREFIX dev nat64

tayga -c /usr/etc/tayga.conf
totd -c /etc/totd.conf

sysctl -w net.ipv6.conf.all.forwarding=1

# forward IPv4
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# iptables -t filter -P FORWARD DROP
# iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

exec "$@"
