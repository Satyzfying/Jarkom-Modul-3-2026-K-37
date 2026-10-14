#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 13
# KELOMPOK 37 (K-37) - 2026
# Replikasi Database Terpusat MariaDB Master-Slave (yaga -> inumaki)
# Database: db_shibuya_k37 | Tabel: request_logs
# ==============================================================================

setup_yaga() {
    echo "=== [YAGA] Mengonfigurasi MariaDB Master ==="
    apt-get update
    apt-get install -y mariadb-server

    mkdir -p /var/log/mysql
    chown -R mysql:mysql /var/log/mysql

    # Konfigurasi Master (bind-address, server-id, log-bin)
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/^#server-id/server-id/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/^#log_bin/log_bin/' /etc/mysql/mariadb.conf.d/50-server.cnf
    grep -q binlog_do_db /etc/mysql/mariadb.conf.d/50-server.cnf || sed -i '/log_bin/a binlog_do_db = db_shibuya_k37' /etc/mysql/mariadb.conf.d/50-server.cnf

    service mariadb restart

    # Buat Database, Tabel, dan Hak Akses
    mariadb -e "CREATE DATABASE IF NOT EXISTS db_shibuya_k37;"
    mariadb -e "USE db_shibuya_k37; CREATE TABLE IF NOT EXISTS request_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        client_ip VARCHAR(50) NOT NULL,
        request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        worker_name VARCHAR(50),
        endpoint VARCHAR(100)
    );"

    # User replikasi
    mariadb -e "CREATE USER IF NOT EXISTS 'replica'@'%' IDENTIFIED BY 'replica_pass';"
    mariadb -e "GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';"

    # User remote untuk seluruh Network 4
    mariadb -e "CREATE USER IF NOT EXISTS 'shibuya_user'@'10.82.4.%' IDENTIFIED BY 'shibuya_pass';"
    mariadb -e "GRANT ALL PRIVILEGES ON db_shibuya_k37.* TO 'shibuya_user'@'10.82.4.%';"
    mariadb -e "FLUSH PRIVILEGES;"

    echo "=== [YAGA] Status Master ==="
    mariadb -e "SHOW MASTER STATUS;"
}

setup_inumaki() {
    echo "=== [INUMAKI] Mengonfigurasi MariaDB Slave ==="
    apt-get update
    apt-get install -y mariadb-server

    # Konfigurasi Slave (bind-address, server-id, read-only)
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/^#server-id/server-id/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/^server-id.*/server-id = 2/' /etc/mysql/mariadb.conf.d/50-server.cnf
    grep -q 'read_only' /etc/mysql/mariadb.conf.d/50-server.cnf || sed -i '/server-id = 2/a read_only = 1' /etc/mysql/mariadb.conf.d/50-server.cnf

    service mariadb restart

    mariadb -e "CREATE DATABASE IF NOT EXISTS db_shibuya_k37;"

    # Hubungkan ke Master Yaga (10.82.4.8)
    MASTER_LOG_FILE=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $1}')
    MASTER_LOG_POS=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $2}')

    echo "Menghubungkan ke Master File: $MASTER_LOG_FILE, Pos: $MASTER_LOG_POS"

    mariadb -e "STOP SLAVE;"
    mariadb -e "CHANGE MASTER TO
        MASTER_HOST='10.82.4.8',
        MASTER_USER='replica',
        MASTER_PASSWORD='replica_pass',
        MASTER_LOG_FILE='$MASTER_LOG_FILE',
        MASTER_LOG_POS=$MASTER_LOG_POS;"
    mariadb -e "START SLAVE;"

    sleep 2
    echo "=== [INUMAKI] Status Replikasi Slave ==="
    mariadb -e "SHOW SLAVE STATUS\G" | grep -E "Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master|Last_Error"
}

test_replication() {
    echo "=== Menguji Replikasi Master -> Slave ==="
    TEST_IP="10.82.2.99"
    mariadb -h 10.82.4.8 -u shibuya_user -pshibuya_pass db_shibuya_k37 -e \
        "INSERT INTO request_logs (client_ip, worker_name, endpoint) VALUES ('$TEST_IP', 'test_worker', '/test/replication');"
    
    sleep 2
    echo "Hasil query di Slave (inumaki):"
    mariadb -e "USE db_shibuya_k37; SELECT * FROM request_logs WHERE client_ip='$TEST_IP';"
}

case "${1:-}" in
    yaga)
        setup_yaga
        ;;
    inumaki)
        setup_inumaki
        ;;
    test)
        test_replication
        ;;
    *)
        echo "Penggunaan: $0 {yaga|inumaki|test}"
        exit 1
        ;;
esac
