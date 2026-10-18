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
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Nanami (10.82.4.5)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Nanami (API Server)",
    "client_ip" => $client_ip
]);
?>
EOF
service nginx restart


# ==== TODO ====
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Todo (10.82.4.6)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Todo (API Server)",
    "client_ip" => $client_ip
]);
?>
EOF
service nginx restart


# ==== KIRARA ====
cat <<'EOF' > /var/www/html/api/index.php
<?php
header("Content-Type: application/json");
$client_ip = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';

try {
    $pdo = new PDO("mysql:host=10.82.4.8;dbname=db_shibuya_k37", "shibuya_user", "shibuya_pass");
    $stmt = $pdo->prepare("INSERT INTO request_logs (client_ip, worker_node) VALUES (?, ?)");
    $stmt->execute([$client_ip, "Kirara (10.82.4.7)"]);
} catch (Exception $e) {}

echo json_encode([
    "status" => "success",
    "message" => "API Shibuya K37 siap melayani",
    "worker" => "Worker Kirara (Backup Server)",
    "client_ip" => $client_ip
]);
?>
EOF
service nginx restart
