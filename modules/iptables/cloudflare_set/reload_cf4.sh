#!/bin/bash

if [! -f "/usr/sbin/ipset"]; then
    echo "/usr/sbin/ipset not found."
    exit 1
fi

/usr/sbin/ipset list cf4 || /usr/sbin/ipset create cf4 hash:net
/usr/sbin/ipset flush cf4

for x in $(curl -s https://www.cloudflare.com/ips-v4); 
    do ipset add cf4 $x; 
done

