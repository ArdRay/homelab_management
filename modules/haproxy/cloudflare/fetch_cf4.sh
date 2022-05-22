#!/bin/bash

[[ -f /usr/bin/curl ]] || exit

[[ -d /etc/haproxy/cloudflare ]] || exit 1

/usr/bin/curl -s https://www.cloudflare.com/ips-v4 > /etc/haproxy/cloudflare/cloudflare_ips-v4.lst
