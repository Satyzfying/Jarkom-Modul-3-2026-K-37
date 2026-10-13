#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 6
# KELOMPOK 37 (K-37) - 2026
# Node: TENGEN (DHCP Server - 10.82.4.10)
# ==============================================================================

# Static Lease Kugisaki (VIP Personal):
# - MAC Address : 02:42:fc:2c:59:00
# - Fixed IP    : 10.82.3.99

cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Class Network 2 (Divisi A)
class "dev" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

class "support" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

# Class Network 3 (Divisi B)
class "short_lease" {
    match if
        substring(hardware, 1, 6) = 02:42:0d:a8:e7:00 or
        substring(hardware, 1, 6) = 02:42:10:fb:eb:00;
}

class "long_lease" {
    match if substring(hardware, 1, 6) = 02:42:df:12:4b:00;
}

# Subnet Network 4 (Data Center - Lokal Tengen)
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Subnet Network 2 (Divisi A)
subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "dev";
    }

    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "support";
    }
}

# Subnet Network 3 (Divisi B)
subnet 10.82.3.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.3.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    # Reservasi Static IP untuk Kugisaki
    host kugisaki {
        hardware ethernet 02:42:fc:2c:59:00;
        fixed-address 10.82.3.99;
    }

    # Pool 1: Short Lease
    pool {
        range 10.82.3.10 10.82.3.89;
        allow members of "short_lease";
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Pool 2: Long Lease
    pool {
        range 10.82.3.100 10.82.3.199;
        allow members of "long_lease";
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

# Validasi dan restart service
dhcpd -t -cf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
service isc-dhcp-server status

# ------------------------------------------------------------------------------
# PENGUJIAN PADA KLIEN KUGISAKI
# Jalankan perintah berikut pada node kugisaki:
# - ip a | grep ether
# - /gns3/bin/udhcpc -f -n -q -i eth0
# ------------------------------------------------------------------------------

