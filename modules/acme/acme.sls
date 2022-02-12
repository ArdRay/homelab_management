# -*- coding: utf-8 -*-
# vim: ft=yaml
---
install_acme:
    cmd.run:
        - name: |
            cd /tmp
            git clone https://github.com/acmesh-official/acme.sh.git
            cd acme.sh
            ./acme.sh --install \
            --home /opt/acme \
            --config-home /opt/acme/config \
            --email "ard@pm.me"
            rm -rf /tmp/acme.sh
            /opt/acme/acme.sh --register-account -m ard@pm.me
        - creates: /opt/acme/acme.sh

{% for certificate in pillar['certificates'] %}
generate_certificates:
    cmd.run:
        - name: /opt/acme/acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d {{ certificate['name'] }}.{{ certificate['position'] }}.mxard.tech
        - env:
            - CF_Zone_ID: {{ pillar['cloudflare']['zone_id'] }}
            - CF_Token: {{ pillar['cloudflare']['token'] }}
        - creates: /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.mxard.tech_ecc/{{ certificate['name'] }}.{{ certificate['position'] }}.mxard.tech.cer
{% endfor %}
