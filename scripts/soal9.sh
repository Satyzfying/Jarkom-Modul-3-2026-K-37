#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 9
# KELOMPOK 37 (K-37) - 2026
# Simulasi Gangguan Service DHCP Relay
# ==============================================================================

# LANGKAH 1: SIMULASI GANGGUAN PADA ROUTER JICHI
# Hentikan service DHCP relay
service isc-dhcp-relay stop
killall dhcrelay 2>/dev/null || true

# LANGKAH 2: PENGUJIAN PADA KLIEN (misal: Miwa di Network 3)
# Paksa meminta lease baru (seharusnya gagal / no lease obtained)
# /gns3/bin/udhcpc -i eth0 -n -q

# LANGKAH 3: PEMULIHAN LAYANAN PADA ROUTER JICHI
# Jalankan kembali service DHCP relay
service isc-dhcp-relay start
# Atau foreground:
# dhcrelay -d -4 -i eth2 -i eth3 10.82.4.10

# LANGKAH 4: PENGUJIAN ULANG PADA KLIEN (Miwa)
# Minta kembali lease DHCP (seharusnya berhasil mendapatkan lease dari 10.82.4.10)
# /gns3/bin/udhcpc -i eth0 -n -q

