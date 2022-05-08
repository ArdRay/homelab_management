# -*- coding: utf-8 -*-
# vim: ft=yaml
---
base:
  'bm-prox-01':
    - modules.node.packages
  'vmk-*':
    - modules.node.interfaces
    - modules.node.packages
    - modules.node.services
    - modules.node.users
  'vmk-cicd-01':
    - hosts.vmk-cicd-01
    - modules.docker.docker
    - modules.acme.acme
    - modules.cicd.cicd
    - modules.iptables.iptables
    - modules.node.monitoring
  'vmk-man-01':
    - hosts.vmk-man-01
    - modules.iptables.iptables
    - modules.node.monitoring
  'vmk-ext-01':
    - hosts.vmk-ext-01
    - modules.acme.acme
    - modules.iptables.iptables
    - modules.haproxy.haproxy
    - modules.node.monitoring
  'vmk-srv-01':
    - hosts.vmk-srv-01
    - modules.docker.docker
    - modules.backup.backup
    - modules.iptables.iptables
    - modules.services.services
    - modules.node.monitoring
  'vmk-rpi-01':
    - hosts.vmk-rpi-01
  'vmk-prod-01':
    - hosts.vmk-prod-01
    - modules.docker.docker
    - modules.backup.backup
    - modules.iptables.iptables
    - modules.node.monitoring
    - modules.prod-01.prod-01
  'vmk-prod-02':
    - hosts.vmk-prod-02
    - modules.docker.docker
    - modules.iptables.iptables
    - modules.node.monitoring
    - modules.prod-02.prod-02