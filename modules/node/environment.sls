# -*- coding: utf-8 -*-
# vim: ft=yaml
---
/root/.bash_profile:
  file.managed:
    - source: salt://files/environment/.bash_profile
    - user: root
    - group: root
    - mode: 644