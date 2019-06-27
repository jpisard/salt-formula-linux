{%- from "linux/map.jinja" import system with context %}

#include:
#- linux.system.package

{%- if system.apparmor.enabled %}

{% for disabled in system.apparmor.get('disabled', []) %}
{% if salt['file.file_exists']('/etc/apparmor.d/'+ disabled ) %}
apparmor_profile_{{ disabled }}:
  file.symlink:
    - name: /etc/apparmor.d/disable/{{ disabled }}
    - target: /etc/apparmor.d/{{ disabled }}

## TODO test if apparmor is running (service with status: Active: failed)
apparmor_parser_{{ disabled }}:
  cmd.run:
    - name: apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd
    - onchanges:
      - file: apparmor_profile_{{ disabled }}
{% endif %}
{% endfor %}

apparmor_service:
  service.running:
  - name: apparmor
  - enable: true
{%- if system.repo|length > 0 %}
  - require:
    - pkg: linux_repo_prereq_pkgs
{%- endif %}
{%- if system.apparmor.get('disabled', [])|length > 0 %}
  - watch:
{% for disabled in system.apparmor.get('disabled', []) %}
    - file: apparmor_profile_{{ disabled }}
{% endfor %}
{%- endif %}

{%- else %}

apparmor_service_disable:
  service.dead:
  - name: apparmor
  - enable: false

apparmor_teardown:
  cmd.wait:
  - name: /etc/init.d/apparmor teardown
  - watch:
    - service: apparmor_service_disable

{%- endif %}
