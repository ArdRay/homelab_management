# -*- coding: utf-8 -*-
# vim: ft=yaml
---

'/etc/cron.scripts':
  file.directory:
    - user: root
    - group: root
    - mode: 740
    - makedirs: True