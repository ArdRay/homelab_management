# -*- coding: utf-8 -*-
# vim: ft=yaml
---

ipset:
  pkg.latest

ipset_c4_script:
  file.managed:
    - mode: 700
    - names:
      - /etc/cron.scripts/reload_cf4.sh:
        - source: salt://modules/iptables/cloudflare_set/reload_cf4.sh

init_cf4_set:
  cmd.run:
    - name: /etc/cron.scripts/reload_cf4.sh
    - cwd: /etc/cron.scripts

reload_cf4_cron:
  cron.present:
    - names:
      - '/bin/bash /etc/cron.scripts/reload_cf4.sh >&2':
        - minute: '0'
