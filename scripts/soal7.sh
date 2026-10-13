#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 7
# KELOMPOK 37 (K-37) - 2026
# Verifikasi Konfigurasi Jaringan & Lease DHCP
# ==============================================================================

# 1. PADA TENGEN (DHCP Server - 10.82.4.10)
# Periksa konfigurasi opsi subnet
grep -A 8 'subnet 10.82.2.0' /etc/dhcp/dhcpd.conf
grep -A 8 'subnet 10.82.3.0' /etc/dhcp/dhcpd.conf

# Cek catatan lease di file lease database
tail -n 100 /var/lib/dhcp/dhcpd.leases
grep -E '^lease 10\.82\.3\.|hardware ethernet|binding state' /var/lib/dhcp/dhcpd.leases
awk '/^lease 10\.82\.[23]\./ {ip=$2} /hardware ethernet/ {print ip, $3}' /var/lib/dhcp/dhcpd.leases

# ------------------------------------------------------------------------------
# 2. PADA MASING-MASING KLIEN (Divisi A: Itadori, Fushiguro, Zenin, Okkotsu)
#                              (Divisi B: Ino, Kusakabe, Kugisaki, Miwa)
# Jalankan perintah verifikasi:
#   ip -4 addr show eth0
#   ip route
#   cat /etc/resolv.conf
# ------------------------------------------------------------------------------

