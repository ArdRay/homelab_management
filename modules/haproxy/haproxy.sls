# -*- coding: utf-8 -*-
# vim: ft=yaml
---

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
      - /etc/haproxy/cloudflare/:
        - user: root
        - group: root
        - mode: 700

haproxy_cf4_script:
  file.managed:
    - mode: 700
    - names:
      - /etc/cron.scripts/fetch_cf4.sh:
        - source: salt://modules/haproxy/cloudflare/fetch_cf4.sh

init_cf4:
  cmd.run:
    - name: /etc/cron.scripts/fetch_cf4.sh
    - cwd: /etc/cron.scripts

fetch_cf4_cron:
  cron.present:
    - names:
      - '/bin/bash /etc/cron.scripts/fetch_cf4.sh >&2':
        - minute: '0'

haproxy:
  pkg.installed:
    - version: 2.2.9-2ubuntu2.1
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
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/haproxy.service
