# -*- coding: utf-8 -*-
# vim: ft=yaml
---

backup_script:
  file.managed:
    - template: jinja
    - mode: 700
    - names:
      - /etc/cron.scripts/backup.sh:
        - source: salt://modules/backup/backup.sh.jinja
        - show_changes: False
