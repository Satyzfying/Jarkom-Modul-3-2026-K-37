#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 3
# KELOMPOK 37 (K-37) - 2026
# Node: JICHI (Router Utama & DHCP Relay)
# Target DHCP Server: TENGEN (10.82.4.10)
# ==============================================================================

# 1. Update package dan install isc-dhcp-relay di Jichi
apt-get update
apt-get install -y isc-dhcp-relay

# 2. Konfigurasi /etc/default/isc-dhcp-relay
# Mengarahkan relay ke DHCP Server Tengen (10.82.4.10)
# Interface client yang dilayani: eth2 (Network 2) dan eth3 (Network 3)
cat <<'EOF' > /etc/default/isc-dhcp-relay
SERVERS="10.82.4.10"
INTERFACES="eth2 eth3"
OPTIONS=""
EOF

# 3. Pastikan IPv4 Forwarding tetap aktif
sysctl -w net.ipv4.ip_forward=1

# 4. Restart service isc-dhcp-relay
service isc-dhcp-relay restart
service isc-dhcp-relay status

# Alternatif: Menjalankan dhcrelay interaktif / debug di terminal foreground:
# dhcrelay -d -4 -i eth2 -i eth3 10.82.4.10

# ------------------------------------------------------------------------------
# PENGUJIAN PADA CLIENT (Divisi A & Divisi B)
# Jalankan perintah berikut pada terminal client (misal: itadori, ino, kusakabe):
# /gns3/bin/udhcpc -f -n -q -i eth0
# ------------------------------------------------------------------------------

