# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/services':
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

ensure_gitea_user_exists:
  user.present:
      - name: gitea-ssh
      - shell: /sbin/nologin
      - createhome: False
      - system: True

docker_services:
  git.latest:
    - name: https://gitlab.com/khomelab_automation/homelab_services.git
    - target: /opt/services
    - rev: services
    - https_user: {{ pillar['git_auth']['homelab_services']['user'] }}
    - https_pass: {{ pillar['git_auth']['homelab_services']['password'] }}
    - force_reset: True
    - force_clone: True
  file.managed:
    - template: jinja
    - names:
      - /opt/services/.env:
        - source: salt://modules/services/env.jinja
        - show_changes: False
      - /opt/services/authelia_server/configuration.yml:
        - source: salt://modules/services/authelia_configuration.yml.jinja
      - /opt/services/grafana/ldap.toml:
        - source: salt://modules/services/grafana_configuration.toml.jinja
      - /opt/services/dns/config.yml:
        - source: salt://modules/shared/dns_config.yml
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/services
    - watch:
      - git: docker_services
      - file: /opt/services/.env
      - file: /opt/services/authelia_server/configuration.yml
      - file: /opt/services/grafana/ldap.toml
      - file: /opt/services/dns/config.yml

backup_services:
  file.managed:
    - template: jinja
    - mode: 700
    - names:
      - /etc/cron.scripts/backup_gitea.sh:
        - source: salt://modules/services/backup/backup_gitea.sh.jinja
        - show_changes: False
  cron.present:
    - names:
      - /bin/bash /etc/cron.scripts/backup_gitea.sh >&2:
        - dayweek: '*/2'
        - hour: '5'
        - minute: '0'