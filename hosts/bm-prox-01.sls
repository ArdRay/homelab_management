# -*- coding: utf-8 -*-
# vim: ft=yaml
---

# TODO: Currently not automated

backup_crons:
  cron.present:
    - names:
      - '/bin/bash /etc/cron.scripts/backup.sh {{ pillar['backups']['prox-01']['repository']['name'] }} personal /hdd_raidz1/personal {{ pillar['healthchecks']['services']['personal'] }} >&2':
        - daymonth: '*/14'
        - hour: '7'
        - minute: '45'