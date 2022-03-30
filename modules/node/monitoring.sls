# -*- coding: utf-8 -*-
# vim: ft=yaml
---

# Install node_exporter
{% set node_version = '1.3.1' %}

node_exporter:
    user.present:
        - shell: /sbin/nologin
        - createhome: False
        - system: True
    cmd.run: 
        - name: |
            curl -o /tmp/node_exporter.tar.gz -L "https://github.com/prometheus/node_exporter/releases/download/v{{ node_version }}/node_exporter-{{ node_version }}.linux-amd64.tar.gz"
            tar -xvzf /tmp/node_exporter.tar.gz -C /tmp/
            mv /tmp/node_exporter-{{ node_version }}.linux-amd64/node_exporter /usr/local/bin/
        - unless: node_exporter --version | grep 'version {{ node_version }}'
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - names:
            - /etc/systemd/system/node_exporter.service:
                - source: salt://files/monitoring/node_exporter.service
            - /etc/sysconfig/node_exporter:
                - source: salt://files/monitoring/node_exporter_options
            - /usr/local/bin/node_exporter:
                - user: node_exporter
                - group: node_exporter
                - mode: 755
    service.running:
        - reload: True
        - enable: True
        - watch:
            - file: /etc/sysconfig/node_exporter

exporter_service:
    cmd.wait:
        - name: systemctl daemon-reload
        - watch:
            - file: /etc/systemd/system/node_exporter.service

#rm -rf /tmp/node_exporter*