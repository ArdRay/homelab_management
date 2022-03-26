# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Install Lua from source
#"cd /tmp && curl -R -O https://www.lua.org/ftp/lua-5.4.4.tar.gz && tar zxf lua-5.4.4.tar.gz && make linux test && make linux install && rm -rf /tmp/lua-5.4.4 && rm /tmp/lua-5.4.4.tar.gz":
#  cmd.run:
#    - unless: test -f /usr/local/bin/lua

# Install HAProxy from source - FLAGS: TARGET=linux-glibc USE_OPENSSL=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1
#"cd /tmp && wget https://www.haproxy.org/download/2.5/src/haproxy-2.5.1.tar.gz && tar zxf haproxy-2.5.1.tar.gz && cd haproxy-2.5.1 && make TARGET=linux-glibc USE_OPENSSL=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1 && make install && rm -rf /tmp/haproxy-2.5.1 && rm /tmp/haproxy-2.5.1.tar.gz":
#  cmd.run:
#    - unless: test -f /usr/local/sbin/haproxy

create_dirs:
  file.directory:
    - makesdirs: True
    - names:
      - /etc/haproxy:
        - user: root
        - group: root
        - mode: 744
      - /var/lib/haproxy/:
        - user: root
        - group: root
        - mode: 744
      - /usr/local/etc/haproxy/:
        - user: root
        - group: root
        - mode: 744
      - /etc/haproxy/certs/:
        - user: root
        - group: root
        - mode: 700

lua-json:
  pkg.installed:
    - version: 1.3.2-9.el8

haproxy:
  pkg.installed:
    - version: 1.8.27-2.el8
  user.present:
    - shell: /sbin/nologin
    - home: /var/lib/haproxy
    - system: True
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - names:
      - /etc/systemd/system/haproxy.service:
        - source: salt://modules/haproxy/haproxy.service
        - mode: 644
      - /etc/haproxy/haproxy.cfg:
        - source: salt://modules/haproxy/haproxy.cfg
      - /usr/share/lua/5.3/haproxy-lua-http.lua:
        - source: https://raw.githubusercontent.com/haproxytech/haproxy-lua-http/master/http.lua
        - skip_verify: True
      - /usr/local/etc/haproxy/auth-request.lua:
        - source: https://raw.githubusercontent.com/TimWolla/haproxy-auth-request/main/auth-request.lua
        - skip_verify: True
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
      - file: /usr/local/etc/haproxy/http.lua
      - file: /usr/local/etc/haproxy/auth-request.lua
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/haproxy.service
