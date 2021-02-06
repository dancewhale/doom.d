#!/bin/bash -xe
iptables -t nat -N REDSOCKS || true
iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 10.88.0.0/16  -j RETURN
iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.1/24   -j RETURN
iptables -t nat -A REDSOCKS -d 172.20.41.0/22 -j RETURN
iptables -t nat -A REDSOCKS -d 172.20.188.0/22 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.1.0/24 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.7.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
# you should prevent trojan 443 to redirect to local.
iptables -t nat -A REDSOCKS -d 107.148.247.15 -j RETURN
iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN

# redirect 12345 is the same to dnat to 127.0.0.1/local interface ip 12345.
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT  --to 12345
iptables -t nat -A REDSOCKS -p udp -j REDIRECT  --to 10053

# 80  443 tcp forward to localhost 12345
iptables -t nat -A OUTPUT    -p tcp --dport 443 -j REDSOCKS
iptables -t nat -A OUTPUT    -p tcp --dport 80 -j REDSOCKS
iptables -t nat -A PREROUTING  -p tcp --dport 443 -j REDSOCKS
iptables -t nat -A PREROUTING  -p tcp --dport 80 -j REDSOCKS

# dns forward to localhost proxy
iptables -t nat -A OUTPUT    -p tcp --dport 53 -j REDSOCKS
iptables -t nat -A OUTPUT    -p udp --dport 53 -j REDSOCKS
iptables -t nat -A PREROUTING  -p tcp --dport 53 -j REDSOCKS
iptables -t nat -A PREROUTING  -p udp --dport 53 -j REDSOCKS
service redsocks start
