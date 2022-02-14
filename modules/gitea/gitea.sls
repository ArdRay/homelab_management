# -*- coding: utf-8 -*-
# vim: ft=yaml
---
/opt/gitea:
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

docker_gitea:
  git.latest:
    - name:  https://git.int.mxard.tech/ard/homelab_services
    - target: /opt/gitea
    - rev: git
    - https_user: {{ pillar['git_auth']['local_git']['user'] }}
    - https_pass: {{ pillar['git_auth']['local_git']['password'] }}
    - force_reset: True
    - force_clone: True
  file.managed:
    - name: /opt/gitea/.env
    - source: salt://modules/gitea/env.jinja
    - template: jinja
    - show_changes: False
  cmd.wait:
    - name: docker-compose up -d --force-recreate --remove-orphans
    - cwd: /opt/gitea
    - watch:
      - git: docker_gitea
      - file: /opt/gitea/.env
