#!/bin/sh

ip_addr=192.168.1.20
mask=24
default_gw=192.168.1.1

# 停止DHCP服务
logger -p syslog.info "停止DHCP服务..."
/etc/init.d/odhcpd stop >/dev/null 2>&1
/etc/init.d/dnsmasq stop >/dev/null 2>&1

# 让wan口支持内网
brctl show > /opt/br.log
ifconfig >> /opt/br.log
ip addr show >> /opt/br.log
brctl addif br-lan eth1 >/dev/null 2>&1
brctl stp br-lan on
ip addr flush eth1 >/dev/null 2>&1
ip addr del 192.168.2.1 dev br-lan >/dev/null 2>&1
ip addr add $ip_addr/$mask dev br-lan >/dev/null 2>&1
ifconfig eth1 up >/dev/null 2>&1
ifconfig br-lan up >/dev/null 2>&1
route del -net 239.0.0.0  netmask 255.0.0.0 >/dev/null 2>&1
route add default gateway $default_gw > /dev/null 2>&1

# 放行IPv6数据包【可选】
logger -p syslog.info "放行IPv6数据包..."
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -F

