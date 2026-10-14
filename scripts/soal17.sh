#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 17
# KELOMPOK 37 (K-37) - 2026
# Pelacakan IP Asli Klien (X-Real-IP & X-Forwarded-For) & Logging Database
# ==============================================================================

test_client_ip_logging() {
    echo "=== Menguji Pelacakan IP Klien & Pencatatan ke Database Yaga ==="
    MY_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "IP Node Penguji: $MY_IP"

    echo "Mengirim request ke http://jujutsu.k37.com/api..."
    RESP=$(curl -s http://jujutsu.k37.com/api)
    echo "Response API: $RESP"

    echo "Memeriksa pencatatan IP pada database Yaga (10.82.4.8):"
    mariadb -h 10.82.4.8 -u shibuya_user -pshibuya_pass db_shibuya_k37 -e \
        "SELECT id, client_ip, request_time, worker_name, endpoint FROM request_logs ORDER BY id DESC LIMIT 5;"
}

case "${1:-}" in
    test)
        test_client_ip_logging
        ;;
    *)
        echo "Penggunaan: $0 test"
        exit 1
        ;;
esac
