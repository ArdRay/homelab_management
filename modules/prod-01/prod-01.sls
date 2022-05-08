# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/prod':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

ensure_proxy_interface_exists:
  cmd.run:
    - name: docker network create t2_proxy
    - unless: docker network ls | grep t2_proxy

ensure_loki_driver_exists:
  cmd.run:
    - name: docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
    - unless: docker plugin ls | grep 'Loki Logging Driver'

docker_prod_01:
  git.latest:
    - name: https://gitlab.com/khomelab_automation/homelab_services.git
    - target: /opt/prod
    - rev: prod-01
    - https_user: {{ pillar['git_auth']['homelab_services']['user'] }}
    - https_pass: {{ pillar['git_auth']['homelab_services']['password'] }}
    - force_reset: True
    - force_clone: True
  file.managed:
    - template: jinja
    - names:
      - /opt/prod/.env:
        - source: salt://modules/prod-01/env.jinja
        - show_changes: False
      - /opt/prod/rente/index.html:
        - source: salt://modules/prod-01/rente/index.html.jinja
        - show_changes: False
      - /opt/prod/sftp/sftp.json:
        - source: salt://modules/prod-01/sftp/sftp.json.jinja
        - show_changes: False
      - /opt/prod/dns/config.yml:
        - source: salt://modules/shared/dns_config.yml
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/prod
    - watch:
      - git: docker_prod_01
      - file: /opt/prod/.env
      - file: /opt/prod/rente/index.html
      - file: /opt/prod/sftp/sftp.json
      - file: /opt/prod/dns/config.yml

backup_crons:
  cron.present:
    - names:
      - '/bin/bash /etc/cron.scripts/backup.sh {{ pillar['backups']['services']['repository']['name'] }} sftp /data/sftp/lexmark {{ pillar['healthchecks']['services']['sftp'] }} >&2':
        - daymonth: '*/2'
        - hour: '5'
        - minute: '30'
      - '/bin/bash /etc/cron.scripts/backup.sh {{ pillar['backups']['services']['repository']['name'] }} ebooks /data/ebooks {{ pillar['healthchecks']['services']['ebooks'] }} >&2':
        - daymonth: '*/5'
        - hour: '1'
        - minute: '30'
      - '/bin/bash /etc/cron.scripts/backup.sh {{ pillar['backups']['services']['repository']['name'] }} photos /data/photos {{ pillar['healthchecks']['services']['photos'] }} >&2':
        - daymonth: '*/2'
        - hour: '15'
        - minute: '0'
      - '/bin/bash /etc/cron.scripts/backup.sh {{ pillar['backups']['services']['repository']['name'] }} photos /data/nextcloud_data {{ pillar['healthchecks']['services']['nextcloud'] }} >&2':
        - daymonth: '*/2'
        - hour: '22'
        - minute: '0'
