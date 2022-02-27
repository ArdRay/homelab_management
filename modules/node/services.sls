# -*- coding: utf-8 -*-
# vim: ft=yaml
---
## SSHD hardening
sshd:
  file.managed:
    - names:
      - /etc/ssh/sshd_config:
        - source: salt://files/sshd/sshd_config
        - user: root
        - group: root
        - mode: 600
      - /etc/ssh/moduli:
        - source: salt://files/sshd/moduli
        - user: root
        - group: root
        - mode: 644
        - show_changes: False
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/moduli

## Ensure basic services are up
{% if grains['os'] == 'Rocky' %}
## NTP
chronyd:
  service.running:
    - enable: True
{% endif %}