#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 4
# KELOMPOK 37 (K-37) - 2026
# Node: TENGEN (DHCP Server - 10.82.4.10)
# ==============================================================================

# 1. Konfigurasi dhcpd.conf dengan Class dan Pool berbasis MAC Address
# MAC Address Klien:
# - Dev (Pool 1: 10.82.2.10 - 10.82.2.35):
#     itadori   : 02:42:ac:b6:01:00
#     fushiguro : 02:42:05:ec:37:00
# - Support (Pool 2: 10.82.2.70 - 10.82.2.95):
#     zenin     : 02:42:43:4a:ba:00
#     okkotsu   : 02:42:08:44:ea:00

cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Definisi Class Dev (Itadori & Fushiguro)
class "dev" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

# Definisi Class Support (Zenin & Okkotsu)
class "support" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

# Network 4: Subnet lokal Tengen (tanpa pool dinamis)
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Network 2: Subnet Divisi A dengan dua Pool terpisah
subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option domain-name-servers 8.8.8.8;

    # Pool 1 untuk Tim Dev (10.82.2.10 - 10.82.2.35)
    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "dev";
    }

    # Pool 2 untuk Tim Support (10.82.2.70 - 10.82.2.95)
    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "support";
    }
}

# Network 3: Subnet Divisi B
subnet 10.82.3.0 netmask 255.255.255.0 {
    range 10.82.3.10 10.82.3.89;
    range 10.82.3.100 10.82.3.199;
    option routers 10.82.3.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}
EOF

# 2. Validasi sintaks konfigurasi
dhcpd -t -cf /etc/dhcp/dhcpd.conf

# 3. Restart service DHCP Server
service isc-dhcp-server restart
service isc-dhcp-server status

# ------------------------------------------------------------------------------
# PENGUJIAN PADA KLIEN DIVISI A
# Jalankan perintah berikut pada terminal masing-masing klien:
# - itadori   : /gns3/bin/udhcpc -f -n -q -i eth0
# - fushiguro : /gns3/bin/udhcpc -f -n -q -i eth0
# - zenin     : /gns3/bin/udhcpc -f -n -q -i eth0
# - okkotsu   : /gns3/bin/udhcpc -f -n -q -i eth0
# ------------------------------------------------------------------------------

