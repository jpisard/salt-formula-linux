linux:
  system:
    enabled: true
    domain: exemple.com
    user:
      shinken:
        name: 'shinken'
        enabled: true
        sudo: false
        shell: /bin/bash
        home: '/home/shinken'
        home_dir_mode: 755
      python_daemon:
        name: 'python_daemon'
        enabled: true
        home: '/home/coalition'
        shell: /bin/false
    package:
      ethtool: ''
      xfsprogs: ''
      sysfsutils: ''
      rsync: ''
      lsyncd: ''
      ntp: 
        version: latest
      mariadb-server: 
        version: latest
      webmin:
        version: latest
    kernel:
      modules:
        - br_netfilter
        - ipmi_devintf
      sysctl:
        vm.swappiness: 20
        net.bridge.bridge-nf-call-ip6tables: 0
        net.bridge.bridge-nf-call-iptables: 0
        net.bridge.bridge-nf-call-arptables: 0
        # network optim
        net.ipv4.tcp_congestion_control: cubic
        net.core.rmem_max: 134217728
        net.core.wmem_max: 134217728
        net.ipv4.tcp_rmem: "4096 87380 134217728"
        net.ipv4.tcp_wmem: "4096 65536 134217728"
        net.core.netdev_max_backlog: 300000
#        net.ipv4.tcp_max_syn_backlog: 8096
        net.ipv4.tcp_moderate_rcvbuf: 1
        net.ipv4.tcp_mtu_probing: 1
        net.ipv4.tcp_timestamps: 1
        net.ipv4.tcp_sack: 1
        net.ipv4.tcp_fin_timeout: 60
    file:
      /home/shinken/.ssh/authorized_keys:
        source: salt://Server/Linux/conf/shinken_authorized_keys
        mode: 600
        user: shinken
    rc:
      local: |
        #!/bin/sh -e
        #
        # rc.local
        #
        # This script is executed at the end of each multiuser runlevel.
        # Make sure that the script will "exit 0" on success or any other
        # value on error.
        #
        # In order to enable or disable this script just change the execution
        # bits.
        #
        # By default this script does nothing.
        ifconfig eth0 txqueuelen 30000
        ethtool -s eth0 autoneg off
        ethtool -K eth0 gso off
    job:
      remove old coalitionlog:
        command: /usr/bin/find /home/coalition/logs/ -type f -mtime +90 -exec rm {} \;
        user: 'root'
        minute: '20'
        hour: '1'
    repo:
      webmin:
        source: "deb http://download.webmin.com/download/repository sarge contrib"
        key_url: "http://www.webmin.com/jcameron-key.asc"
    rsyncd:
      enabled: true
      max_connections: 30
      read_only: True
      module:
        sharedapp:
          path: /home/data/sharedapp
          read_only: False
#          incoming_chmod: Du=rwx,Dgo=rwx,Fug=rw,Fo=r
          uid: root
        echangeStudio:
          path: /home/data/echange/Studio
          uid: root
          gid: 10513
          read_only: False

    lsyncd:
      enabled: true
      module:
        /home/data/echange/Studio/:
          targetlist:
            - 192.168.100.4::echangeStudio/
          exclude:
            - '.*'
          delay: 15
          compress: true
          update: true
          perms: true
          delete: "'running'"
          _extra:
            - '--bwlimit=400'

        /home/data/sharedapp/:
          targetlist:
            - 192.168.100.4::sharedapp/
          exclude:
            - 'lost+found'
          delay: 15
          compress: true
          update: true
          perms: true
          delete: "'running'"
          _extra:
            - '--bwlimit=800'
    

  network:
    enabled: true
    fqdn: coalition-ang.exemple.com
    resolv:
      dns:
      - 192.168.101.1
      - 192.168.100.1
      domain: exemple.com
      search:
      - internal.exemple.com
    interface:
      eth0:
        enabled: true
        type: eth
        address: 192.168.101.25
        netmask: 255.255.255.0
        gateway: 192.168.101.254


