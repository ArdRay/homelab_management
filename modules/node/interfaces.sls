# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% if grains['os'] == 'Rocky' %}
  {% for filename in salt['cp.list_master'](prefix='files/ifcfg') %}
    {% if grains['host'] in filename %}
      {% set interface_name = filename.split('/')[2].split('@')[0] %}
      /etc/sysconfig/network-scripts/ifcfg-{{ interface_name }}:
        file.managed:
          - source: salt://files/ifcfg/{{ interface_name }}@{{ grains['host'] }}
        cmd.wait:
          - name: nmcli networking off; nmcli networking on
          - watch:
            - file: /etc/sysconfig/network-scripts/ifcfg-{{ interface_name }}
    {% endif %}
  {% endfor %}
{% elif grains['os'] == 'Ubuntu' %}
  {% set filename = 'netplan@' + grains['host']|string %}
    {% if filename in salt['cp.list_master'](prefix='files/ifcfg') %}
      /etc/netplan/00-installer-config.yaml:
        file.managed:
          - source: salt://files/ifcfg/netplan@{{ grains['host'] }}
        cmd.wait:
          - name: netplan apply
          - watch:
            - file: /etc/netplan/00-installer-config.yaml
    {% endif %}
{% endif %}
