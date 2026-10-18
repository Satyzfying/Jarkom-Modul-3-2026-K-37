#!/bin/bash

# ==== MAKI ====
apt-get update
apt-get install -y nginx php-fpm
mkdir -p /var/www/html
rm -f /var/www/html/index.nginx-debian.html

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

cat <<'EOF' > /var/www/html/index.php
<?php
echo "Halo dari Frontend Worker: Maki (10.82.4.3)\n";
?>
EOF

service php8.4-fpm restart 2>/dev/null || service php-fpm restart 2>/dev/null || true
service nginx restart


# ==== PANDA ====
apt-get update
apt-get install -y nginx php-fpm
mkdir -p /var/www/html
rm -f /var/www/html/index.nginx-debian.html

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

cat <<'EOF' > /var/www/html/index.php
<?php
echo "Halo dari Frontend Worker: Panda (10.82.4.4)\n";
?>
EOF

service php8.4-fpm restart 2>/dev/null || service php-fpm restart 2>/dev/null || true
service nginx restart


# ==== NANAMI ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/api

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Nanami (10.82.4.5)",
    "ip" => "10.82.4.5"
]);
?>
EOF

service php8.4-fpm restart 2>/dev/null || service php-fpm restart 2>/dev/null || true
service nginx restart


# ==== TODO ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/api

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Todo (10.82.4.6)",
    "ip" => "10.82.4.6"
]);
?>
EOF

service php8.4-fpm restart 2>/dev/null || service php-fpm restart 2>/dev/null || true
service nginx restart


# ==== KIRARA ====
apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/api

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Kirara (10.82.4.7)",
    "ip" => "10.82.4.7"
]);
?>
EOF

service php8.4-fpm restart 2>/dev/null || service php-fpm restart 2>/dev/null || true
service nginx restart


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
