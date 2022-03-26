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
{% if not certificate['position'] == 'ext' %}
generate_{{ certificate['name'] }}_{{ certificate['position'] }}_{{ certificate['domain'] }}_certificate:
    cmd.run:
        - name: /opt/acme/acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d {{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}
        - env:
            - CF_Token: {{ pillar['cloudflare']['token'] }}
            - CF_Account_ID: {{ pillar['cloudflare']['account_id'] }}
            - CF_Zone_ID: {{ pillar['cloudflare']['zone_id'] }}
        - creates: /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}.cer
generate_{{ certificate['name'] }}_{{ certificate['position'] }}_{{ certificate['domain'] }}_haproxy_compatible:
    cmd.run:
        - name: cat /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}.key /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}_ecc/fullchain.cer | tee /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}.pem > /dev/null
        - creates: /.acme.sh/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['position'] }}.{{ certificate['domain'] }}.pem
{% else %}
generate_{{ certificate['name'] }}_{{ certificate['position'] }}_{{ certificate['domain'] }}_certificate:
    cmd.run:
        - name: /opt/acme/acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-384 -d {{ certificate['name'] }}.{{ certificate['domain'] }}
        - env:
            - CF_Token: {{ pillar['cloudflare']['token'] }}
            - CF_Account_ID: {{ pillar['cloudflare']['account_id'] }}
            - CF_Zone_ID: {{ pillar['cloudflare']['zone_id'] }}
        - creates: /.acme.sh/{{ certificate['name'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['domain'] }}.cer
generate_{{ certificate['name'] }}_{{ certificate['position'] }}_{{ certificate['domain'] }}_haproxy_compatible:
    cmd.run:
        - name: cat /.acme.sh/{{ certificate['name'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['domain'] }}.key /.acme.sh/{{ certificate['name'] }}.{{ certificate['domain'] }}_ecc/fullchain.cer | tee /.acme.sh/{{ certificate['name'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['domain'] }}.pem > /dev/null
        - creates: /.acme.sh/{{ certificate['name'] }}.{{ certificate['domain'] }}_ecc/{{ certificate['name'] }}.{{ certificate['domain'] }}.pem
{% endif %}
{% endfor %}

include:
    - modules.node.environment
