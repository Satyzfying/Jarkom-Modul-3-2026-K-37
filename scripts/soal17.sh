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

    set_real_ip_from 10.82.1.4;
    real_ip_header X-Forwarded-For;
    real_ip_recursive on;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
nginx -t && service nginx restart


# ==== NANAMI ====
mkdir -p /var/www/api /var/www/html/api
cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'];
if (strpos($client_ip, ',') !== false) {
    $parts = explode(',', $client_ip);
    $client_ip = trim($parts[0]);
}

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Nanami (10.82.4.5)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Nanami (10.82.4.5)",
    "client_ip" => $client_ip
]);
?>
EOF
cp /var/www/api/index.php /var/www/html/api/index.php
service nginx reload


# ==== TODO ====
mkdir -p /var/www/api /var/www/html/api
cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'];
if (strpos($client_ip, ',') !== false) {
    $parts = explode(',', $client_ip);
    $client_ip = trim($parts[0]);
}

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Todo (10.82.4.6)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Todo (10.82.4.6)",
    "client_ip" => $client_ip
]);
?>
EOF
cp /var/www/api/index.php /var/www/html/api/index.php
service nginx reload


# ==== KIRARA ====
mkdir -p /var/www/api /var/www/html/api
cat <<'EOF' > /var/www/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'];
if (strpos($client_ip, ',') !== false) {
    $parts = explode(',', $client_ip);
    $client_ip = trim($parts[0]);
}

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Kirara (10.82.4.7)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Kirara (10.82.4.7)",
    "client_ip" => $client_ip
]);
?>
EOF
cp /var/www/api/index.php /var/www/html/api/index.php
service nginx reload
