#!/bin/bash

# ==== MAKI ====
apt-get update
apt-get install -y nginx php-fpm
mkdir -p /var/www/html
cat <<'EOF' > /var/www/html/index.php
<?php
echo "Halo dari Frontend Worker: Maki (10.82.4.3)\n";
?>
EOF
service nginx restart
service php-fpm restart 2>/dev/null || service php8.2-fpm restart 2>/dev/null || true


# ==== PANDA ====
apt-get update
apt-get install -y nginx php-fpm
mkdir -p /var/www/html
cat <<'EOF' > /var/www/html/index.php
<?php
echo "Halo dari Frontend Worker: Panda (10.82.4.4)\n";
?>
EOF
service nginx restart
service php-fpm restart 2>/dev/null || service php8.2-fpm restart 2>/dev/null || true


# ==== NANAMI ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/html/api
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Nanami (API Server)",
    "ip" => "10.82.4.5"
]);
?>
EOF
service nginx restart
service php-fpm restart 2>/dev/null || service php8.2-fpm restart 2>/dev/null || true


# ==== TODO ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/html/api
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Todo (API Server)",
    "ip" => "10.82.4.6"
]);
?>
EOF
service nginx restart
service php-fpm restart 2>/dev/null || service php8.2-fpm restart 2>/dev/null || true


# ==== KIRARA ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/html/api
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Kirara (Backup Server)",
    "ip" => "10.82.4.7"
]);
?>
EOF
service nginx restart
service php-fpm restart 2>/dev/null || service php8.2-fpm restart 2>/dev/null || true


# ==== GETO ====
apt-get update
apt-get install -y nginx
cat <<'EOF' > /etc/nginx/sites-available/default
upstream api_cluster {
    server 10.82.4.5:80;
    server 10.82.4.6:80;
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


# ==== GOJO ====
apt-get update
apt-get install -y nginx curl
cat <<'EOF' > /etc/nginx/sites-available/default
upstream frontend_cluster {
    server 10.82.4.3:80;
    server 10.82.4.4:80;
}

server {
    listen 80 default_server;
    server_name jujutsu.k37.com www.jujutsu.k37.com _;

    location / {
        proxy_pass http://frontend_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /api {
        proxy_pass http://10.82.4.2/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
nginx -t && service nginx restart
