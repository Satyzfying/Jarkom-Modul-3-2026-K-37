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
service named restart
