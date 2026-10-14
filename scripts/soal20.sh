#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 20
# KELOMPOK 37 (K-37) - 2026
# Audit Beban Layanan Menggunakan Apache Benchmark (Kusakabe)
# ==============================================================================

run_benchmark() {
    echo "=== [KUSAKABE] Audit Beban Layanan Menggunakan Apache Benchmark ==="
    if ! command -v ab >/dev/null 2>&1; then
        echo "Menginstall apache2-utils..."
        apt-get update && apt-get install -y apache2-utils
    fi

    echo "======================================================================"
    echo "1. BENCHMARK FRONTEND WEB: http://jujutsu.k37.com/ (-n 600 -c 30)"
    echo "======================================================================"
    ab -n 600 -c 30 http://jujutsu.k37.com/ > /tmp/ab_frontend.txt 2>&1
    grep -E "Server Software|Requests per second|Time per request|Failed requests|Complete requests" /tmp/ab_frontend.txt

    echo ""
    echo "======================================================================"
    echo "2. BENCHMARK API WORKER: http://jujutsu.k37.com/api (-n 600 -c 30)"
    echo "   (Menguji Efek Rate Limiting 10 r/s)"
    echo "======================================================================"
    ab -n 600 -c 30 http://jujutsu.k37.com/api > /tmp/ab_api.txt 2>&1
    grep -E "Server Software|Requests per second|Time per request|Failed requests|Non-2xx responses|Complete requests" /tmp/ab_api.txt
}

check_logs() {
    echo "=== [GOJO] Memeriksa Access Log Nginx untuk Membedakan Status ==="
    echo "--- 10 Log Akses Terakhir di Gojo ---"
    tail -n 10 /var/log/nginx/access.log
}

case "${1:-}" in
    benchmark)
        run_benchmark
        ;;
    logs)
        check_logs
        ;;
    *)
        echo "Penggunaan: $0 {benchmark|logs}"
        exit 1
        ;;
esac
