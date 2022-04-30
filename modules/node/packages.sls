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

{% if grains['osarch'] == 'arm64' %}
install_restic:
  file.managed:
    - name: /usr/local/bin/restic
    - source: salt://files/packages/restic_0.13.1_linux_arm64
    - source_hash: 9062e56b98173ae9b000e2cf867d388577442863c83ac3b6a48e90a776cf75ad
    - user: root
    - group: root
    - if_missing: /usr/local/bin/restic
{% endif %}

#{% if grains['os'] == 'Ubuntu' %}
#install_restic:
#  archive.extracted:
#    - name: /usr/local/bin/restic
#    - source: salt://files/packages/restic_0.13.1_linux_amd64
#    - source_hash: a7a82eca050224c9cd070fea1d4208fe92358c5942321d6e01eff84a77839fb8
#    - user: root
#    - group: root
#    - if_missing: /usr/local/bin/restic
#{% endif %}