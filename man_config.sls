# -*- coding: utf-8 -*-
# vim: ft=yaml
---
include:
  - modules.docker.docker
  - modules.gitea.gitea
  - modules.acme.acme

gitea:
  firewalld.service:
    - name: gitea
    - ports:
      - 80/tcp
      - 2222/tcp

public:
  firewalld.present:
    - name: public
    - default: True
    - interfaces:
      - ens18
    - masquerade: False
    - services:
      - ssh
      - salt-master
      - gitea
    - sources:
      - 10.0.0.0/8
