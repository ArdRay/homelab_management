# -*- coding: utf-8 -*-
# vim: ft=yaml
---
public:
  firewalld.present:
    - name: public
    - default: True
    - interfaces:
      - ens18
    - masquerade: False
    - services:
      - ssh
    - sources:
      - 10.0.0.0/8

/etc/sysconfig/network-scripts/ifcfg-ens18:
  file.managed:
    - source: salt://files/ifcfg/ens18@{{ grains['host'] }}

'systemctl restart NetworkManager':
  cmd.run:
    - onchanges:
      - file: /etc/sysconfig/network-scripts/ifcfg-ens18
  