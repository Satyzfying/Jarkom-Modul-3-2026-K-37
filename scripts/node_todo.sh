apt-get update
apt-get install -y nginx php-fpm php-mysql
mkdir -p /var/www/api
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    server_name jujutsu.k37.com www.jujutsu.k37.com _;
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
cat <<'EOF' > /var/www/api/index.php
<?php
header('Content-Type: application/json');

$client_ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'];
if (strpos($client_ip, ',') !== false) {
    $parts = explode(',', $client_ip);
    $client_ip = trim($parts[0]);
}

$worker = gethostname();
$endpoint = $_SERVER['REQUEST_URI'];

try {
    $mysqli = new mysqli('10.82.4.8', 'shibuya_user', 'shibuya_pass', 'db_shibuya_k37');
    if (!$mysqli->connect_errno) {
        $stmt = $mysqli->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
        $stmt->bind_param("ss", $client_ip, $worker);
        $stmt->execute();
        $stmt->close();
        $mysqli->close();
    }
} catch (Exception $e) {
}

echo json_encode([
    "status" => "success",
    "worker" => $worker,
    "client_ip" => $client_ip,
    "endpoint" => $endpoint,
    "message" => "Request processed by API worker {$worker}"
]);
?>
EOF
service php8.4-fpm restart
service nginx restart
