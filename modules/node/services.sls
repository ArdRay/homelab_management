# -*- coding: utf-8 -*-
# vim: ft=yaml
---
## SSHD hardening
sshd:
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/moduli
  file.managed:
    - name: /etc/ssh/sshd_config
    - user: root
    - group: root
    - mode: 600
    - source: salt://files/sshd/sshd_config
  cmd.run:
    - name: awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli
    - unless: if (( `awk '$5 < 3071' /etc/ssh/moduli | wc -l` > 0 )); then exit 1; fi

{% if grains['os'] == 'Rocky' %}
## NTP
chronyd:
  service.running:
    - enable: True
## Firewalld
firewalld:
  service.running:
    - enable: True
{% endif %}