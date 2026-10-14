#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 10
# KELOMPOK 37 (K-37) - 2026
# Pemulihan & Autostart DHCP Server (Tengen) dan DHCP Relay (Jichi) Setelah Restart
# ==============================================================================

# ==============================================================================
# BAGIAN A: DIJALANKAN PADA NODE TENGEN (DHCP Server - 10.82.4.10)
# ==============================================================================
setup_tengen() {
    echo "=== [TENGEN] Mengonfigurasi DHCP Server & Autostart ==="
    
    # 1. Install paket jika belum tersedia
    if ! command -v dhcpd >/dev/null 2>&1; then
        apt-get update
        apt-get install -y isc-dhcp-server
    fi

    # 2. Tentukan interface DHCP Server
    sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server
    grep -q '^INTERFACESv4=' /etc/default/isc-dhcp-server || echo 'INTERFACESv4="eth0"' >> /etc/default/isc-dhcp-server

    # 3. Konfigurasi dhcpd.conf lengkap (Pool 1, Pool 2, Short Lease, Long Lease, Fixed IP)
    cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;

option domain-name "k37.com";
option domain-name-servers 10.82.1.2, 10.82.1.3;

default-lease-time 3600;
max-lease-time 43200;

# Subnet Network 4 (Lokal Tengen - Data Center)
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Subnet Network 2 (Divisi A)
class "POOL1" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

class "POOL2" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option broadcast-address 10.82.2.255;

    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "POOL1";
    }

    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "POOL2";
    }
}

# Subnet Network 3 (Divisi B)
class "SHORT_LEASE" {
    match if
        substring(hardware, 1, 6) = 02:42:0d:a8:e7:00 or
        substring(hardware, 1, 6) = 02:42:10:fb:eb:00;
}

class "LONG_LEASE" {
    match if substring(hardware, 1, 6) = 02:42:df:12:4b:00;
}

subnet 10.82.3.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.3.1;
    option broadcast-address 10.82.3.255;

    # Static Lease VIP Kugisaki
    host kugisaki {
        hardware ethernet 02:42:fc:2c:59:00;
        fixed-address 10.82.3.99;
    }

    # Short Lease (Ino & Kusakabe: 1800 detik)
    pool {
        range 10.82.3.10 10.82.3.89;
        allow members of "SHORT_LEASE";
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Long Lease (Miwa: 43200 detik)
    pool {
        range 10.82.3.100 10.82.3.199;
        allow members of "LONG_LEASE";
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

    # 4. Validasi sintaks
    dhcpd -t -4 -cf /etc/dhcp/dhcpd.conf

    # 5. Aktifkan autostart pada boot
    update-rc.d isc-dhcp-server defaults
    service isc-dhcp-server restart
    
    echo "=== [TENGEN] Konfigurasi selesai. Status: ==="
    service isc-dhcp-server status || true
    ls -l /etc/rc2.d/ | grep isc-dhcp-server || true
}

# ==============================================================================
# BAGIAN B: DIJALANKAN PADA NODE JICHI (Router & DHCP Relay - 10.82.x.1)
# ==============================================================================
setup_jichi() {
    echo "=== [JICHI] Mengonfigurasi DHCP Relay & Autostart ==="

    # 1. Install DHCP Relay jika belum tersedia
    if [ ! -x /usr/sbin/dhcrelay ]; then
        apt-get update
        apt-get install -y isc-dhcp-relay
    fi

    # 2. Hentikan instance relay lama
    service isc-dhcp-relay stop 2>/dev/null || true
    pkill -x dhcrelay 2>/dev/null || true

    # 3. Buat script runner relay
    cat <<'EOF' > /usr/local/sbin/start-dhcrelay-soal10.sh
#!/bin/sh
pkill -x dhcrelay 2>/dev/null || true
sleep 1
/usr/sbin/dhcrelay -4 -id eth2 -id eth3 -iu eth4 10.82.4.10 >/tmp/dhcrelay.log 2>&1 &
EOF
    chmod +x /usr/local/sbin/start-dhcrelay-soal10.sh

    # 4. Buat init script dhcrelay-custom
    cat <<'EOF' > /etc/init.d/dhcrelay-custom
#!/bin/sh
case "$1" in
    start)
        echo "Menjalankan DHCP Relay..."
        /usr/local/sbin/start-dhcrelay-soal10.sh
        sleep 2
        pgrep -af dhcrelay || true
        ;;
    stop)
        pkill -x dhcrelay 2>/dev/null || true
        echo "DHCP Relay dihentikan."
        ;;
    restart)
        "$0" stop
        sleep 1
        "$0" start
        ;;
    status)
        pgrep -af dhcrelay || true
        ;;
    *)
        echo "Penggunaan: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF
    chmod +x /etc/init.d/dhcrelay-custom

    # 5. Daftarkan service ke runlevel
    update-rc.d dhcrelay-custom defaults 2>/dev/null || true

    # 6. Pasang autostart di /etc/rc.local
    if [ ! -f /etc/rc.local ]; then
        cat <<'EOF' > /etc/rc.local
#!/bin/sh
exit 0
EOF
    fi

    if ! grep -q 'dhcrelay-custom start' /etc/rc.local; then
        sed -i '/^exit 0/d' /etc/rc.local
        cat <<'EOF' >> /etc/rc.local
sleep 3
/etc/init.d/dhcrelay-custom start
exit 0
EOF
    fi
    chmod +x /etc/rc.local

    # 7. Jalankan service relay
    /etc/init.d/dhcrelay-custom restart
    
    echo "=== [JICHI] Konfigurasi selesai. Status: ==="
    pgrep -af dhcrelay || true
}

case "${1:-}" in
    tengen)
        setup_tengen
        ;;
    jichi)
        setup_jichi
        ;;
    *)
        echo "Penggunaan: $0 {tengen|jichi}"
        exit 1
        ;;
esac