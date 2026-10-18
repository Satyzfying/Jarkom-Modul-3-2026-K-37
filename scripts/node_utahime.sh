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
    listen-on { any; };
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
service named restart

