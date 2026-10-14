#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 11
# KELOMPOK 37 (K-37) - 2026
# DNS Master-Slave BIND9 (utahime sebagai Master & shoko sebagai Slave)
# Domain: jujutsu.k37.com
# ==============================================================================

setup_utahime() {
    echo "=== [UTAHIME] Mengonfigurasi BIND9 DNS Master ==="
    apt-get update
    apt-get install -y bind9 bind9utils dnsutils

    mkdir -p /etc/bind/zones

    cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

    cat <<'EOF' > /etc/bind/named.conf.local
zone "jujutsu.k37.com" {
    type master;
    file "/etc/bind/zones/db.jujutsu.k37.com";
    allow-transfer { 10.82.1.3; };
    also-notify { 10.82.1.3; };
};

zone "1.82.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.82.1";
    allow-transfer { 10.82.1.3; };
    also-notify { 10.82.1.3; };
};
EOF

    cat <<'EOF' > /etc/bind/zones/db.jujutsu.k37.com
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

utahime IN      A       10.82.1.2
shoko   IN      A       10.82.1.3

@       IN      A       10.82.1.4
www     IN      CNAME   jujutsu.k37.com.
EOF

    named-checkconf
    named-checkzone jujutsu.k37.com /etc/bind/zones/db.jujutsu.k37.com
    service named restart
    service named status
}

setup_shoko() {
    echo "=== [SHOKO] Mengonfigurasi BIND9 DNS Slave ==="
    apt-get update
    apt-get install -y bind9 bind9utils dnsutils

    cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

    cat <<'EOF' > /etc/bind/named.conf.local
zone "jujutsu.k37.com" {
    type slave;
    file "/var/cache/bind/db.jujutsu.k37.com";
    masters { 10.82.1.2; };
};

zone "1.82.10.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.10.82.1";
    masters { 10.82.1.2; };
};
EOF

    chown -R bind:bind /var/cache/bind
    named-checkconf
    service named restart
    service named status
}

case "${1:-}" in
    utahime)
        setup_utahime
        ;;
    shoko)
        setup_shoko
        ;;
    *)
        echo "Penggunaan: $0 {utahime|shoko}"
        exit 1
        ;;
esac

