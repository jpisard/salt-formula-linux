{%- from "linux/map.jinja" import system with context %}

{% if system.xen.enabled is defined and system.xen.enabled %}

{% if not salt['file.file_exists']('/usr/lib/xen') %}
{% set virtual_hv_version=grains.get('virtual_hv_version', None) %}
{% if virtual_hv_version %}
{% set xen_version='.'.join(virtual_hv_version.split('.')[0:-1]) %}

{% if salt['file.directory_exists']('/usr/lib/xen-' ~ xen_version ) %}

createlink:
    file.symlink:
        - name: /usr/lib/xen
        - target: /usr/lib/xen-{{ xen_version }}

{% endif %}
{% endif %}
{% endif %}

{% if salt['file.file_exists']('/etc/grub.d/20_linux_xen') %}

divert_grub:
    cmd.run:
        - name: dpkg-divert --divert /etc/grub.d/08_linux_xen --rename /etc/grub.d/20_linux_xen
{% endif %}

{% if system.xen.grub is defined %}
xen_grub:
      file.managed:
        - name: /etc/default/grub.d/xen.cfg
        - template: jinja
        - source: salt://linux/files/xen.cfg
        - makedirs: True        

xen_grub_update:
      cmd.run:
        - name: update-grub
        - onchanges: 
          - file: /etc/default/grub.d/xen.cfg

{% endif %}

{% if not salt['file.file_exists']('/etc/apparmor.d/disable/usr.sbin.libvirtd') %}


##ln -s /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/usr.sbin.libvirtd
##apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd

{% endif %}

{% if system.xen.xendomains is defined -%}

    xen_domains:
        file.managed:
            - name: /etc/default/xendomains
            - template: jinja
            - source: salt://linux/files/xendomains
{%- endif %}



##xenservice:
##    cmd.run:
##        - name: systemctl disable xendomains.service

#/lib/systemd/system/xendriverdomain.service:
#    file.managed:
#        - source: salt://linux/files/xendriverdomain.service
#        - template: jinja

#systemd-reload:
#  cmd.run:
#   - name: systemctl --system daemon-reload
#   - onchanges:  
#     - file: /lib/systemd/system/xendriverdomain.service

#xendriverdomain:
#  service.running:
#    - enable: True
#    - onchanges:  
#      - file: /lib/systemd/system/xendriverdomain.service

{% endif %}
