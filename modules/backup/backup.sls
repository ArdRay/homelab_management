# -*- coding: utf-8 -*-
# vim: ft=yaml
---

backup_script:
  file.managed:
    - template: jinja
    - mode: 700
    - names:
      - /etc/cron.scripts/backup.sh:
{% if grains['host'] == 'bm-prox-01' %}
        - source: salt://modules/backup/backup_bm.sh.jinja
{% else %}
        - source: salt://modules/backup/backup.sh.jinja
{% endif %}
        - show_changes: False
