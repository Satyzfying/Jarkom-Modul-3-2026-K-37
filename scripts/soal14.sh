#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 14
# KELOMPOK 37 (K-37) - 2026
# Backend Workers Nginx + PHP-FPM & Pembatasan Akses Langsung Klien
# ==============================================================================

test_access_restriction() {
    echo "=== Menguji Pembatasan Akses Langsung Klien ke Worker ==="
    echo "--- 1. Akses langsung dari Klien ke Worker Frontend (maki: 10.82.4.3) ---"
    curl -I -s --connect-timeout 2 http://10.82.4.3/ | head -n 1

    echo "--- 2. Akses langsung dari Klien ke Worker API (nanami: 10.82.4.5) ---"
    curl -I -s --connect-timeout 2 http://10.82.4.5/ | head -n 1

    echo "--- 3. Akses legal melalui Gojo Reverse Proxy ---"
    curl -s http://10.82.1.4/
    echo ""
    curl -s http://10.82.1.4/api
    echo ""
}

case "${1:-}" in
    test)
        test_access_restriction
        ;;
    *)
        echo "Penggunaan: $0 test"
        exit 1
        ;;
esac
