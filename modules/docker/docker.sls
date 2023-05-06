# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Docker installation
yum-utils:
  pkg.latest:
    - refresh: True

/etc/yum.repos.d/docker-ce.repo:
  file.managed:
    - source: salt://modules/docker/docker-ce.repo
    - user: root
    - group: root
    - mode: 644

docker-ce:
  pkg.installed:
    - version: 23.0.5-1.el8

/etc/docker/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

docker:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/docker/daemon.json
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://modules/docker/daemon.json
    - user: root
    - group: root
    - mode: 644

/usr/local/bin/docker-compose:
  file.managed:
    - source: https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64
    - source_hash: https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64.sha256
    - mode: 755

include:
    - modules.node.environment