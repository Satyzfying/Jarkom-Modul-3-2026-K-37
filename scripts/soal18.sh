#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 18
# KELOMPOK 37 (K-37) - 2026
# Failover API Cluster ke Backup Worker (kirara) & Passive Health Check
# ==============================================================================

test_failover() {
    echo "=== Menguji Failover API ke Backup Worker (Kirara) ==="
    echo "--- 1. Kondisi Normal (Nanami & Todo Aktif) ---"
    for i in 1 2 3; do
        curl -s http://jujutsu.k37.com/api | grep -o '"worker":"[^"]*"'
    done

    echo ""
    echo "--- Simulasi: Hentikan Nginx di Nanami & Todo ---"
    echo "Jalankan di node nanami: service nginx stop"
    echo "Jalankan di node todo  : service nginx stop"
    echo ""
    echo "--- 2. Pengujian Saat Nanami & Todo Padam ---"
    for i in 1 2 3; do
        RESP=$(curl -s -w "\nHTTP_STATUS:%{http_code}\n" http://jujutsu.k37.com/api)
        echo "$RESP" | grep -E '"worker"|HTTP_STATUS'
    done
}

case "${1:-}" in
    test)
        test_failover
        ;;
    *)
        echo "Penggunaan: $0 test"
        exit 1
        ;;
esac
