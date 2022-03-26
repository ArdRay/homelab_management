# -*- coding: utf-8 -*-
# vim: ft=yaml
---
base:
  '*':
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
  'vmk-man-01':
    - hosts.vmk-man-01
    - modules.docker.docker
    - modules.management.management
    - modules.acme.acme
    - modules.iptables.iptables
  'vmk-ext-01':
    - hosts.vmk-ext-01
    - modules.docker.docker
    - modules.iptables.iptables
    - modules.external.external
  'vmk-srv-01':
    - hosts.vmk-srv-01
    - modules.docker.docker
    - modules.iptables.iptables
    - modules.services.services
  'vmk-rpi-01':
    - hosts.vmk-rpi-01
  'vmk-prod-01':
    - hosts.vmk-prod-01
    - modules.docker.docker
    - modules.iptables.iptables