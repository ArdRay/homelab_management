# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/services':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

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
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/services
    - watch:
      - git: docker_services
      - file: /opt/services/.env