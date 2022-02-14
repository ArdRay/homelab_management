# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% if grains['os'] == 'Rocky' %}
/etc/sysconfig/network-scripts/ifcfg-ens18:
  file.managed:
    - source: salt://files/ifcfg/ens18@{{ grains['host'] }}

'systemctl restart NetworkManager':
  cmd.run:
    - onchanges:
      - file: /etc/sysconfig/network-scripts/ifcfg-ens18
{% endif %}
