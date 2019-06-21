{%- from "linux/map.jinja" import system with context %}


{% if system.lsyncd.enabled is defined and system.lsyncd.enabled %}

lsyncd_directory:
  file.directory:
    - name: /etc/lsyncd
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

default_lsyncd:
        file.managed:
            - name: /etc/lsyncd/lsyncd.conf.lua
            - source: salt://linux/files/lsyncd.conf.lua


config_lsyncd:
    file.managed:
        - name: /etc/lsyncd/config.lua
        - template: jinja
        - source: salt://linux/files/lsyncd_config.lua
        - default:
            module['delay']: 1

lsyncd_restart:
  module.run:
    - service.restart:
      - name: lsyncd
    - onchanges:
      - file: config_lsyncd
      - file: default_lsyncd

{% endif %}
