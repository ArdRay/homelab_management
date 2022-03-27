# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% if grains['os'] == 'Rocky' %}
  {% set iptables_file = '/etc/sysconfig/iptables' %}
{% elif grains['os'] == 'Ubuntu' %}
  {% set iptables_file = '/etc/iptables/rules.v4' %}
{% endif %}

iptables:
  service.running:
    - enable: True
    - reload: True
    {% if grains['os'] == 'Rocky' %}
    - onchanges:
      - file: /etc/sysconfig/iptables-config
    {% endif %}

iptables_files:
  file.managed:
    - user: root
    - group: root
    - mode: 0600
    - names:
      {% if grains['os'] == 'Rocky' %}
      - /etc/sysconfig/iptables-config:
        - source: salt://modules/iptables/iptables-config
      - /etc/sysconfig/iptables_docker_reload:
        - source: salt://modules/iptables/iptables_docker_reload
        - mode: 0750
      {% endif %}
      - {{ iptables_file }}:
        - source: salt://files/iptables/iptables@{{ grains['host'] }}
        - check_cmd: /usr/sbin/iptables-restore -t 
  {% if grains['os'] == 'Rocky' %}
  cmd.wait:
    - name: bash /etc/sysconfig/iptables_docker_reload
    - watch:
      - file: {{ iptables_file }}
  {% endif %}
