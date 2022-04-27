# -*- coding: utf-8 -*-
# vim: ft=yaml
---
'/opt/healthchecks':
  file.directory:
    - user: ops
    - group: ops
    - mode: 740
    - makedirs: True

install_dependencies:
  pkg.latest:
    - pkgs:
      - gcc 
      - python3-dev 
      - python3-venv
      - virtualenv
      - libpq-dev
      - nginx

config_files:
  file.managed:
    - user: ops
    - group: ops
    - names:
      - /etc/nginx/conf.d/healthchecks.int.mxard.cloud.conf:
        - template: jinja
        - source: salt://modules/healthchecks/nginx/nginx.conf.jinja
      - /etc/systemd/system/healthchecks.service:
        - source: salt://modules/healthchecks/healthchecks_server.service
      - /etc/systemd/system/healthchecks_alerts.service:
        - source: salt://modules/healthchecks/healthchecks_alerts.service
      - /etc/sysconfig/healthchecks_server:
        - template: jinja
        - source: salt://modules/healthchecks/healthchecks_variables.jinja

/opt/healthchecks/venv:
  git.cloned:
    - name: https://github.com/healthchecks/healthchecks.git
    - target: /opt/healthchecks/healthchecks
  virtualenv.managed:
    - requirements: /opt/healthchecks/healthchecks/requirements.txt
    - pip_upgrade: True
#  cmd.run:
#    - cwd: /opt/healthchecks
#    - names:
#      - source venv/bin/activate && cd /opt/healthchecks/healthchecks && ./manage.py migrate
#        - creates: /opt/healthchecks/migrated

nginx: 
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/nginx/conf.d/healthchecks.int.mxard.cloud.conf

healthchecks:
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /opt/healthchecks/healthchecks
      - file: /etc/sysconfig/healthchecks_server
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/healthchecks.service

healthchecks_alerts:
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /opt/healthchecks/healthchecks
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/healthchecks_alerts.service