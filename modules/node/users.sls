# -*- coding: utf-8 -*-
# vim: ft=yaml
---
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

# Ubuntu specific - unlock account for SSH
{% if grains['os'] == 'Ubuntu' %}
"usermod -p '*' ard":
  cmd.run:
    - unless: grep ard /etc/shadow | grep -F ":*:"
"usermod -p '*' ops":
  cmd.run:
    - unless: grep ops /etc/shadow | grep -F ":*:"
{% endif %}