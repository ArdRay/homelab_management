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

'https://github.com/healthchecks/healthchecks.git':
  git.cloned:
    target: /opt/healthchecks

/opt/healthchecks/venv:
  virtualenv.managed:
    - requirements: /opt/healthchecks/healthchecks/requirements.txt
    - use_wheel: True
        
