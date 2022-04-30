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
      - iptables
      - net-tools
      - restic
      {% if grains['os'] == 'Rocky' %}
      - pinentry
      - vim-enhanced
      - iptables-services
      {% elif grains['os'] == 'Ubuntu' %}
      - vim
      - cron
      - iptables-persistent
      - iputils-ping
      {% endif %}

remove_default_packageds:
  pkg.purged:
    - pkgs:
      - firewalld
