# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/cicd':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

docker_cicd:
  git.latest:
    - name: https://gitlab.com/khomelab_automation/homelab_services.git
    - target: /opt/cicd
    - rev: cicd
    - https_user: {{ pillar['git_auth']['homelab_services']['user'] }}
    - https_pass: {{ pillar['git_auth']['homelab_services']['password'] }}
    - force_reset: True
    - force_clone: True
  file.managed:
    - template: jinja
    - names:
      - /opt/cicd/.env:
        - source: salt://modules/cicd/env.jinja
        - show_changes: False
      - /opt/cicd/nginx/nginx.conf:
        - source: salt://modules/cicd/nginx.conf.jinja
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/cicd
    - watch:
      - git: docker_cicd
      - file: /opt/cicd/nginx/nginx.conf
      - file: /opt/cicd/.env
