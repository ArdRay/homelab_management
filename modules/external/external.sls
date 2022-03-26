# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/external':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

docker_external:
  git.latest:
    - name: https://gitlab.com/khomelab_automation/homelab_services.git
    - target: /opt/external
    - rev: external
    - https_user: {{ pillar['git_auth']['homelab_services']['user'] }}
    - https_pass: {{ pillar['git_auth']['homelab_services']['password'] }}
    - force_reset: True
    - force_clone: True
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/external
    - watch:
      - git: docker_external
