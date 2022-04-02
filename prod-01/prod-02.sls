# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/prod':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

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
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/prod
    - watch:
      - git: docker_prod_01
      - file: /opt/prod/.env
