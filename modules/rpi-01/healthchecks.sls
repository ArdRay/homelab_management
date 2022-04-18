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

/opt/healthchecks/venv:
  git.cloned:
    - name: https://github.com/healthchecks/healthchecks.git
    - target: /opt/healthchecks/healthchecks
    - force_reset: True
    - force_clone: True
  virtualenv.managed:
    - requirements: /opt/healthchecks/healthchecks/requirements.txt
    - use_wheel: True
    - pip_upgrade: True
        
