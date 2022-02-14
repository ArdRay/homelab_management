# -*- coding: utf-8 -*-
# vim: ft=yaml
---
base:
  '*':
    - default_config
  'vmk-cicd-01':
    - hosts.vmk-cicd-01
    - modules.docker.docker
    - modules.acme.acme
    - modules.cicd.cicd
  'vmk-man-01':
    - hosts.vmk-man-01
    - modules.docker.docker
    - modules.gitea.gitea
    - modules.acme.acme
  'vmk-ext-01':
    - hosts.vmk-ext-01
  'vmk-srv-01':
    - hosts.vmk-srv-01
  'vmk-rpi-01':
    - hosts.vmk-rpi-01