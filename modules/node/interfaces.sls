# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% if grains['os'] == 'Rocky' %}
  {% for filename in salt['cp.list_master'](prefix='files/ifcfg') %}
    {% if grains['host'] in filename %}
      {% set interface_name = filename.split('/')[3].split('@')[1] %}

      /etc/sysconfig/network-scripts/ifcfg-{{ interface_name }}:
        file.managed:
          - source: salt://files/ifcfg/{{ filename }}

      'systemctl restart NetworkManager':
        cmd.run:
          - onchanges:
            - file: /etc/sysconfig/network-scripts/{{ filename }}

    {% endif %}
  {% endfor %}
{% endif %}
