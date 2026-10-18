#!/bin/bash

# ==== UTAHIME ====
cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
        8.8.8.8;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
    dnssec-validation no;
};
EOF

service named restart


# ==== SHOKO ====
cat <<'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
        8.8.8.8;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on { any; };
    listen-on-v6 { any; };
    dnssec-validation no;
};
EOF

service named restart
