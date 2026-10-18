apt-get update
apt-get install -y nginx php-fpm
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name jujutsu.k37.com www.jujutsu.k37.com _;
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
cat <<'EOF' > /var/www/html/index.php
<?php
$hostname = gethostname();
echo "Hello from Frontend Worker: " . htmlspecialchars($hostname) . "\n";
?>
EOF
service php8.4-fpm restart
service nginx restart
