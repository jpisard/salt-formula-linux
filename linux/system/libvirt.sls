{%- from "linux/map.jinja" import system with context %}


/usr/lib/libvirt/libvirt-guests.sh:
  file.replace:
  - pattern: 'echo "$list" | grep -v 00000000-0000-0000-0000-000000000000$'
  - repl: echo "$list" | grep -v 00000000-0000-0000-0000-000000000000 | tr \\\\n ' '


{% if system.libvirt.enabled is defined and system.libvirt.enabled %}

{% if system.libvirt.guest is defined -%}
    default_libvirt-guest:
        file.managed:
            - name: /etc/default/libvirt-guest
            - template: jinja
            - source: salt://linux/files/libvirt-guest

{%- endif %}
{% endif %}