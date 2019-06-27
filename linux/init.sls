{% from "map.jinja" import saltconfig with context %}
{%- if pillar.linux is defined %}

{{ saltconfig.folder }}/minion.d/_superseded.conf:
    file.managed:
        - source: salt://linux/files/_superseded.conf
        - onchanges_in:
            - Restart Salt Minion in minion

Restart Salt Minion in minion:
  cmd.run:
    - name: '{{ saltconfig.saltcall }} service.restart salt-minion'
    - bg: True
    - watch:
        - file: {{ saltconfig.folder }}/minion.d/_superseded.conf

include:
{%- if pillar.linux.system is defined %}
- linux.system
{%- endif %}
{%- if pillar.linux.network is defined %}
- linux.network
{%- endif %}
{%- if pillar.linux.storage is defined %}
- linux.storage
{%- endif %}
{%- endif %}
