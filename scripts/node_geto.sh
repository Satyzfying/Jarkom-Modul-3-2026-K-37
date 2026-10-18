apt-get update
apt-get install -y nginx
cat <<'EOF' > /etc/nginx/sites-available/default
upstream api_cluster {
    server 10.82.4.5:80 weight=3 max_fails=2 fail_timeout=5s;
    server 10.82.4.6:80 weight=1 max_fails=2 fail_timeout=5s;
    server 10.82.4.7:80 backup;
}

server {
    listen 80 default_server;
    server_name jujutsu.k37.com www.jujutsu.k37.com _;

    set_real_ip_from 10.82.1.4;
    real_ip_header X-Forwarded-For;
    real_ip_recursive on;

    location / {
        proxy_pass http://api_cluster;
        proxy_connect_timeout 2s;
        proxy_read_timeout 3s;
        proxy_next_upstream error timeout http_502 http_503;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
nginx -t
service nginx restart
