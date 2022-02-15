# -*- coding: utf-8 -*-
# vim: ft=yaml
---
pkg.latest:
  - pkgs:
    - make
    - gcc
    - perl
    - pcre-devel
    - zlib-devel
    - wget 
    - openssl-devel 
    - readline-devel
    - systemd-devel

# "/etc/haproxy":
#   file.directory:
#     - user: root
#     - group: root
#     - makedirs: True

# Install Lua from source
"cd /tmp && curl -R -O https://www.lua.org/ftp/lua-5.4.4.tar.gz && tar zxf lua-5.4.4.tar.gz && make linux test && make linux install && rm -rf /tmp/lua-5.4.4 && rm /tmp/lua-5.4.4.tar.gz":
  cmd.run:
    - unless: 
      - test -f /usr/local/bin/lua

# Install HAProxy from source
"cd /tmp && wget https://www.haproxy.org/download/2.5/src/haproxy-2.5.1.tar.gz && tar zxf haproxy-2.5.1.tar.gz && cd haproxy-2.5.1 && make TARGET=linux-glibc USE_OPENSSL=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1 && make install && rm -rf /tmp/haproxy-2.5.1 && rm /tmp/haproxy-2.5.1.tar.gz":
  cmd.run:
    - unless:
      - test -f /usr/local/sbin/haproxy

# "/etc/haproxy/haproxy.cfg":
#   file.managed:
#     - source: salt://modules/haproxy/haproxy.cfg
#     - user: root
#     - group: root
#     - mode: 744

# "/etc/systemd/system/haproxy.d":
#   file.directory:
#     - user: root
#     - group: root
#     - mode: 755
#     - makedirs: True

# "/etc/systemd/system/haproxy.d/haproxy.service":
#   file.managed:
#     - source: salt://modules/haproxy/haproxy.service
#     - user: root
#     - group: root
#     - mode: 744

haproxy_service:
  file.directory:
    - user: root
    - group: root
    - mode: 744
    - names:
      - /etc/haproxy
      - /etc/systemd/system/haproxy.d
  file.managed:
    - user: root
    - group: root
    - mode: 744
    - names:
      - /etc/systemd/system/haproxy.d/haproxy.service:
        - source: salt://modules/haproxy/haproxy.service
      - /etc/haproxy/haproxy.cfg:
        - source: salt://modules/haproxy/haproxy.cfg
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/haproxy.d/haproxy.service
