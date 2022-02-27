# -*- coding: utf-8 -*-
# vim: ft=yaml
---
install_iptables:
  pkg.latest:
    - pkgs:
      - iptables
      - iptables-services

remove_filewalld:
  pkg.purged:
    - pkgs:
      - firewalld

iptables:
  service.running:
    - enable: True
    - reload: True

iptables_files:
  file.managed:
    - user: root
    - group: root
    - mode: 0600
    - names:
      - /etc/sysconfig/iptables-config:
        - source: salt://modules/iptables/iptables-config
      - /etc/sysconfig/iptables:
        - source: salt://files/iptables/iptables@{{ grains['host'] }}
        - check_cmd: /usr/sbin/iptables-restore -t 
  cmd.wait_script:
    - name: /etc/sysconfig/iptables_docker_reload
    - source: salt://modules/iptables/iptables_docker_reload
    - user: root
    - group: root
    - mode: 0750
    - onchanges:
      - file: /etc/sysconfig/iptables