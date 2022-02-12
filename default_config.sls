# -*- coding: utf-8 -*-
# vim: ft=yaml
---
## Packages
{% if grains['os'] == 'Rocky' %}
epel-release:
  pkg.latest:
    - refresh: True
{% endif %}

install_default_packages:
  pkg.latest:
    - pkgs:
      - curl
      - git
      - rsync
      - htop
      {% if grains['os'] == 'Rocky' %}
      - pinentry
      - vim-enhanced
      {% elif grains['os'] == 'Ubuntu' %}
      - vim
      {% endif %}

## Users
ops:
  user.present:
    - shell: /bin/bash
    - home: /home/ops

ard:
  user.present:
    - shell: /bin/bash
    - home: /home/ard

/etc/sudoers:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/sudoers/sudoers@{{ grains['os'] }}
    - check_cmd: visudo -c -f

sshkeys:
  ssh_auth.manage:
    - user: ard
    - enc: ssh-ed25519
    - ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuX2Py5v7WswGOiPvLnBuV+jhDYpl15KrLp9MafgN6e
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICquToJ6AELUkLfQLWilvf3uL0O8TJuc5X3p97vGZY96

## SSHD hardening
"awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli":
  cmd.run:
    - unless: if (( `awk '$5 < 3071' /etc/ssh/moduli | wc -l` > 0 )); then exit 1; fi

sshd:
  service.running:
    - reload: True
    - enable: True
    - watch:
      - file: /etc/ssh/sshd_config
  file.managed:
    - name: /etc/ssh/sshd_config
    - user: root
    - group: root
    - mode: 600
    - source: salt://files/sshd/sshd_config

# Ubuntu specific - unlock account for SSH
{% if grains['os'] == 'Ubuntu' %}
"usermod -p '*' ard":
  cmd.run:
    - unless: grep ard /etc/shadow | grep -F ":*:"
"usermod -p '*' ops":
  cmd.run:
    - unless: grep ops /etc/shadow | grep -F ":*:"
{% endif %}

{% if grains['os'] == 'Rocky' %}
## NTP
chronyd:
  service.running:
    - enable: True
## Firewalld
firewalld:
  service.running:
    - enable: True
{% endif %}

/root/.bash_profile:
  file.managed:
    - source: salt://files/environment/.bash_profile
    - user: root
    - group: root
    - mode: 644