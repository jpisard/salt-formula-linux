{%- from "linux/map.jinja" import rsyncd with context %}

{% if rsyncd.enabled is defined and rsyncd.enabled %}

rsync_packages:
  pkg.installed:
  - names: {{ rsyncd.pkgs }}

rsync_config:
  file.managed:
  - name: /etc/rsyncd.conf
  - source: salt://linux/files/rsyncd.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - pkg: rsync_packages

rsync_startup_config:
  file.managed:
  - name: {{ rsyncd.config }}
  - source: salt://linux/files/rsync
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
    - pkg: rsync_packages

rsync_service:
  service.running:
  - name: {{ rsyncd.service }}
  - enable: true
  - watch:
    - file: rsync_config
    - file: rsync_startup_config

{%- endif %}

