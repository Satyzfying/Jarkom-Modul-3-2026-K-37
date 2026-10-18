#!/bin/bash

# ==== YAGA (MASTER) ====
apt-get update
apt-get install -y mariadb-server

mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^#server-id/server-id/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^#log_bin/log_bin/' /etc/mysql/mariadb.conf.d/50-server.cnf
grep -q binlog_do_db /etc/mysql/mariadb.conf.d/50-server.cnf || sed -i '/log_bin/a binlog_do_db = db_shibuya_k37' /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb restart

mariadb -e "CREATE DATABASE IF NOT EXISTS db_shibuya_k37;"
mariadb -e "USE db_shibuya_k37; CREATE TABLE IF NOT EXISTS test_sync (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesan VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"
mariadb -e "USE db_shibuya_k37; CREATE TABLE IF NOT EXISTS request_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_ip VARCHAR(50) NOT NULL,
    worker_node VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"

mariadb -e "CREATE USER IF NOT EXISTS 'replica'@'10.82.4.%' IDENTIFIED BY 'replica_pass';"
mariadb -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT, BINLOG MONITOR ON *.* TO 'replica'@'10.82.4.%';"

mariadb -e "CREATE USER IF NOT EXISTS 'shibuya_user'@'10.82.4.%' IDENTIFIED BY 'shibuya_pass';"
mariadb -e "GRANT ALL PRIVILEGES ON db_shibuya_k37.* TO 'shibuya_user'@'10.82.4.%';"
mariadb -e "FLUSH PRIVILEGES;"


# ==== INUMAKI (SLAVE) ====
apt-get update
apt-get install -y mariadb-server

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^#server-id/server-id/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^server-id.*/server-id = 2/' /etc/mysql/mariadb.conf.d/50-server.cnf
grep -q 'read_only' /etc/mysql/mariadb.conf.d/50-server.cnf || sed -i '/server-id = 2/a read_only = 1' /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb restart

mariadb -e "CREATE DATABASE IF NOT EXISTS db_shibuya_k37;"
mariadb -e "USE db_shibuya_k37; CREATE TABLE IF NOT EXISTS test_sync (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pesan VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"
mariadb -e "USE db_shibuya_k37; CREATE TABLE IF NOT EXISTS request_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_ip VARCHAR(50) NOT NULL,
    worker_node VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"

LOG_FILE=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $1}')
LOG_POS=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $2}')

mariadb -e "STOP SLAVE;"
mariadb -e "CHANGE MASTER TO MASTER_HOST='10.82.4.8', MASTER_USER='replica', MASTER_PASSWORD='replica_pass', MASTER_LOG_FILE='$LOG_FILE', MASTER_LOG_POS=$LOG_POS;"
mariadb -e "START SLAVE;"
