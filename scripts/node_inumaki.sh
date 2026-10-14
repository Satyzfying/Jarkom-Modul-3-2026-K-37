apt-get update
apt-get install -y mariadb-server
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^#server-id/server-id/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/^server-id.*/server-id = 2/' /etc/mysql/mariadb.conf.d/50-server.cnf
grep -q 'read_only' /etc/mysql/mariadb.conf.d/50-server.cnf || sed -i '/server-id = 2/a read_only = 1' /etc/mysql/mariadb.conf.d/50-server.cnf
service mariadb restart
mariadb -e "CREATE DATABASE IF NOT EXISTS db_shibuya_k37;"
mariadb db_shibuya_k37 -e "CREATE TABLE IF NOT EXISTS request_logs (id INT AUTO_INCREMENT PRIMARY KEY, client_ip VARCHAR(50) NOT NULL, request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, worker_name VARCHAR(50), endpoint VARCHAR(100));"
LOG_FILE=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $1}')
LOG_POS=$(mariadb -h 10.82.4.8 -u replica -preplica_pass -N -e "SHOW MASTER STATUS;" | awk '{print $2}')
mariadb -e "STOP SLAVE;"
mariadb -e "CHANGE MASTER TO MASTER_HOST='10.82.4.8', MASTER_USER='replica', MASTER_PASSWORD='replica_pass', MASTER_LOG_FILE='$LOG_FILE', MASTER_LOG_POS=$LOG_POS;"
mariadb -e "START SLAVE;"
