# -*- coding: utf-8 -*-
# vim: ft=yaml
---
/opt/management:
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

docker_management:
  git.latest:
    - name:  https://gitlab.com/doxmael/homelab_services.git
    - target: /opt/management
    - rev: management
    - https_user: {{ pillar['git_auth']['homelab_services']['management']['user'] }}
    - https_pass: {{ pillar['git_auth']['homelab_services']['management']['password'] }}
    - force_reset: True
    - force_clone: True
  file.managed:
    - template: jinja
    - show_changes: False
    - names: 
      - /opt/management/.env:
        - source: salt://modules/management/env.jinja
      - /opt/management/authelia_server/configuration.yml:
        - source: salt://modules/management/authelia_configuration.yml.jinja
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/management
    - watch:
      - git: docker_management
      - file: /opt/management/.env
      - file: /opt/management/authelia_server/configuration.yml
