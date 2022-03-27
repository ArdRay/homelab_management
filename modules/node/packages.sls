
## Packages
{% if grains['os'] == 'Rocky' %}
epel-release:
  pkg.latest:
    - refresh: True
{% endif %}

install_default_packages:
  pkg.latest:
    - pkgs:
      - curl
      - git
      - rsync
      - htop
      - cron
      - crontab
      - iptables
      - net-tools
      {% if grains['os'] == 'Rocky' %}
      - pinentry
      - vim-enhanced
      - iptables-services
      {% elif grains['os'] == 'Ubuntu' %}
      - vim
      - iptables-persistent
      - iputils-ping
      {% endif %}

remove_default_packageds:
  pkg.purged:
    - pkgs:
      - firewalld