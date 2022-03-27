
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
      {% if grains['os'] == 'Rocky' %}
      - pinentry
      - vim-enhanced
      {% elif grains['os'] == 'Ubuntu' %}
      - vim
      - net-tools
      - iputils-ping
      {% endif %}