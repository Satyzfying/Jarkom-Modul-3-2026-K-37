#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 2
# KELOMPOK 37 (K-37) - 2026
# Node: TENGEN (DHCP Server - 10.82.4.10)
# ==============================================================================

# 1. Update repository dan instalasi paket isc-dhcp-server
apt-get update
apt-get install -y isc-dhcp-server

# 2. Konfigurasi interface yang didengarkan oleh DHCP Server
cat <<'EOF' > /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF

# 3. Konfigurasi dhcpd.conf
cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Network 4: subnet lokal Tengen, tidak membagikan IP dinamis
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Network 2
subnet 10.82.2.0 netmask 255.255.255.0 {
    range 10.82.2.10 10.82.2.35;
    option routers 10.82.2.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}

# Network 3
subnet 10.82.3.0 netmask 255.255.255.0 {
    range 10.82.3.10 10.82.3.89;
    range 10.82.3.100 10.82.3.199;
    option routers 10.82.3.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}
EOF

# 4. Validasi sintaks konfigurasi dhcpd
dhcpd -t -cf /etc/dhcp/dhcpd.conf

# 5. Restart dan cek status service isc-dhcp-server
service isc-dhcp-server restart
service isc-dhcp-server status

# 6. Pastikan autostart aktif
systemctl enable isc-dhcp-server 2>/dev/null || true

