#!/bin/bash

# ==== MAKI ====
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
    index index.php index.html;

    allow 10.82.1.4;
    deny all;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
nginx -t && service nginx reload


# ==== PANDA ====
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
    index index.php index.html;

    allow 10.82.1.4;
    deny all;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
nginx -t && service nginx reload


# ==== NANAMI ====
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    allow 10.82.4.2;
    deny all;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
nginx -t && service nginx reload


# ==== TODO ====
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    allow 10.82.4.2;
    deny all;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
nginx -t && service nginx reload


# ==== KIRARA ====
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name _;
    root /var/www/api;
    index index.php;

    allow 10.82.4.2;
    deny all;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF
nginx -t && service nginx reload
