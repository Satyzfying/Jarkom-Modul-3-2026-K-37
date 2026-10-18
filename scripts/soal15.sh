#!/bin/bash

# ==== GETO ====
cat <<'EOF' > /etc/nginx/sites-available/default
upstream api_cluster {
    server 10.82.4.5:80 weight=3;
    server 10.82.4.6:80 weight=1;
    server 10.82.4.7:80 backup;
}

server {
    listen 80 default_server;
    server_name _;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx restart
