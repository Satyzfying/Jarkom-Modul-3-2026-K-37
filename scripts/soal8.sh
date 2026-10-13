#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 8
# KELOMPOK 37 (K-37) - 2026
# Pembuktian Paket DHCP (DORA) melalui DHCP Relay
# ==============================================================================

# 1. PADA JICHI (Router & DHCP Relay)
# Jalankan dhcrelay secara interaktif/debug untuk mengamati giaddr:
# dhcrelay -d -4 -i eth2 -i eth3 10.82.4.10

# 2. PADA TENGEN (DHCP Server)
# Tangkap proses pertukaran paket DHCP atau periksa syslog daemon dhcpd:
# tcpdump -i eth0 -n -vvv port 67 or port 68
# atau pantau log daemon:
# tail -f /var/log/syslog | grep -E 'DHCPDISCOVER|DHCPOFFER|DHCPREQUEST|DHCPACK'

# 3. PADA KLIEN (misal: Miwa di Network 3)
# Minta lease baru:
# /gns3/bin/udhcpc -i eth0 -n -q

