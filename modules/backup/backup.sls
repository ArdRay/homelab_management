# -*- coding: utf-8 -*-
# vim: ft=yaml
---

'/etc/cron.scripts':
  file.directory:
    - user: root
    - group: root
    - mode: 740
    - makedirs: True

backup_script:
  file.managed:
    - template: jinja
    - mode: 700
    - names:
      - /etc/cron.scripts/backup.sh:
        - source: salt://modules/backup/backup.sh.jinja
        - show_changes: False
