# -*- coding: utf-8 -*-
# vim: ft=yaml
---
ubuntu:
  user.absent:
    - purge: True

disable_cloudinit:
  file.managed:
    - name: /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
    - source: salt://files/cloud_init/vmk-rpi-01.cfg
    