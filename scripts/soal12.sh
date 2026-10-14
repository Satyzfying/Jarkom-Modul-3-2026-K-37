#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 12
# KELOMPOK 37 (K-37) - 2026
# DNS Forwarder, A Record Gojo, CNAME www, dan Reverse DNS PTR
# ==============================================================================

setup_utahime() {
    echo "=== [UTAHIME] Menyiapkan Zona Reverse PTR & Verifikasi Record ==="
    mkdir -p /etc/bind/zones

    cat <<'EOF' > /etc/bind/zones/db.10.82.1
$TTL    604800
@       IN      SOA     utahime.jujutsu.k37.com. root.jujutsu.k37.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      utahime.jujutsu.k37.com.
@       IN      NS      shoko.jujutsu.k37.com.

2       IN      PTR     utahime.jujutsu.k37.com.
3       IN      PTR     shoko.jujutsu.k37.com.
4       IN      PTR     jujutsu.k37.com.
EOF

    named-checkzone 1.82.10.in-addr.arpa /etc/bind/zones/db.10.82.1
    service named restart
    service named status
}

verify_client() {
    echo "=== [CLIENT] Menguji DNS Query CNAME, PTR, dan Akses Internet ==="
    echo "--- 1. Query A Record jujutsu.k37.com ---"
    dig @10.82.1.2 jujutsu.k37.com +short
    dig @10.82.1.3 jujutsu.k37.com +short

    echo "--- 2. Query CNAME Record www.jujutsu.k37.com ---"
    dig @10.82.1.2 www.jujutsu.k37.com

    echo "--- 3. Query Reverse DNS PTR 10.82.1.4 ---"
    dig @10.82.1.2 -x 10.82.1.4 +short
    dig @10.82.1.3 -x 10.82.1.4 +short

    echo "--- 4. Uji DNS Forwarder ke Internet (google.com) ---"
    ping -c 2 google.com
}

case "${1:-}" in
    utahime)
        setup_utahime
        ;;
    client)
        verify_client
        ;;
    *)
        echo "Penggunaan: $0 {utahime|client}"
        exit 1
        ;;
esac

