apt-get update
apt-get install -y nginx curl
mkdir -p /var/cache/nginx
chown -R www-data:www-data /var/cache/nginx
cat <<'EOF' > /etc/nginx/sites-available/default
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=FRONTEND_CACHE:10m inactive=10m max_size=100m;
limit_req_zone $binary_remote_addr zone=API_LIMIT:10m rate=10r/s;

upstream frontend_cluster {
    server 10.82.4.3:80;
    server 10.82.4.4:80;
}

server {
    listen 80 default_server;
    server_name jujutsu.k37.com www.jujutsu.k37.com _;

    location / {
        proxy_pass http://frontend_cluster;
        proxy_cache FRONTEND_CACHE;
        proxy_cache_valid 200 302 10m;
        add_header X-Cache-Status $upstream_cache_status;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /api {
        limit_req zone=API_LIMIT;
        limit_req_status 429;
        proxy_pass http://10.82.4.2/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
nginx -t
service nginx restart
