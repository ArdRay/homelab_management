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
