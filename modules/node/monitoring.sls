# -*- coding: utf-8 -*-
# vim: ft=yaml
---

# Install node_exporter
{% set node_version = '1.3.1' %}

install_node_exporter:
    cmd.run: 
        - name: |
            curl -o /tmp/node_exporter.tar.gz -L "https://github.com/prometheus/node_exporter/releases/download/v{{ node_version }}/node_exporter-{{ node_version }}.linux-amd64.tar.gz"
            tar -xvzf /tmp/node_exporter.tar.gz -C /tmp/
            mv /tmp/node_exporter-{{ node_version }}.linux-amd64/node_exporter /usr/local/bin/
            rm -rf /tmp/node_exporter*
        - unless: node_exporter --version | grep 'version {{ node_version }}'

node_exporter:
    user.present:
        - shell: /sbin/nologin
        - createhome: False
        - system: True
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - names:
            - /etc/systemd/system/node_exporter.service:
                - source: salt://files/monitoring/node_exporter.service
            - /etc/sysconfig/node_exporter:
                - source: salt://files/monitoring/node_exporter_options
                - makedirs: True
            - /usr/local/bin/node_exporter:
                - user: node_exporter
                - group: node_exporter
                - mode: 755
                - replace: False
    cmd.wait:
        - name: systemctl daemon-reload
        - watch:
            - file: /etc/systemd/system/node_exporter.service
    service.running:
        - reload: True
        - enable: True
        - watch:
            - file: /etc/sysconfig/node_exporter

{% if if grains['selinux'] is defined %}
    {% if grains['selinux']['enabled'] == True %}
    node_exporter_selinux_fcontext:
        selinux.fcontext_policy_present:
            - name: '/usr/local/bin/node_exporter'
            - sel_type: bin_t

    node_exporter_selinux_fcontext_applied:
        selinux.fcontext_policy_applied:
            - name: '/usr/local/bin/node_exporter'
    {% endif %}
{% endif %}


