#!/bin/bash
./init.sh


mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    echo "`date` Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi
iptables-restore  < /opt/ovpn_data/iptables.rules

sysctl -w net.ipv4.ip_forward=1
dnsmasq -C /opt/ovpn_data/dnsmasq.conf
openvpn --config /opt/ovpn_data/server.conf 
