#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 19
# KELOMPOK 37 (K-37) - 2026
# Proxy Caching (10m) & Rate Limiting (10 req/s) pada Gojo
# ==============================================================================

test_cache() {
    echo "=== Menguji Proxy Caching Frontend (Header X-Cache-Status) ==="
    echo "--- Request 1 (Initial / Cache MISS) ---"
    curl -s -I http://jujutsu.k37.com/ | grep -iE "HTTP|X-Cache-Status"

    sleep 1
    echo "--- Request 2 (Subsequent / Cache HIT) ---"
    curl -s -I http://jujutsu.k37.com/ | grep -iE "HTTP|X-Cache-Status"

    sleep 1
    echo "--- Request 3 (Subsequent / Cache HIT) ---"
    curl -s -I http://jujutsu.k37.com/ | grep -iE "HTTP|X-Cache-Status"
}

test_rate_limit() {
    echo "=== Menguji Rate Limiting pada Endpoint /api (Maks 10 r/s) ==="
    echo "Mengirim 25 request beruntun secara cepat ke http://jujutsu.k37.com/api..."
    
    COUNT_200=0
    COUNT_429=0
    COUNT_OTHER=0

    for i in $(seq 1 25); do
        CODE=$(curl -s -o /dev/null -w "%{http_code}" http://jujutsu.k37.com/api)
        if [ "$CODE" = "200" ]; then
            COUNT_200=$((COUNT_200 + 1))
        elif [ "$CODE" = "429" ] || [ "$CODE" = "503" ]; then
            COUNT_429=$((COUNT_429 + 1))
        else
            COUNT_OTHER=$((COUNT_OTHER + 1))
        fi
        echo -n "$CODE "
    done
    echo ""
    echo "Hasil pengujian Rate Limit:"
    echo " - HTTP 200 (Diterima): $COUNT_200 request"
    echo " - HTTP 429/503 (Dibatasi/Rate Limited): $COUNT_429 request"
    echo " - Status Lain: $COUNT_OTHER request"
}

case "${1:-}" in
    cache)
        test_cache
        ;;
    rate-limit)
        test_rate_limit
        ;;
    all)
        test_cache
        echo ""
        test_rate_limit
        ;;
    *)
        echo "Penggunaan: $0 {cache|rate-limit|all}"
        exit 1
        ;;
esac
