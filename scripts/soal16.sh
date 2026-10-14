#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 16
# KELOMPOK 37 (K-37) - 2026
# Public Reverse Proxy Gojo - Path-Based Routing (/ dan /api)
# ==============================================================================

test_routing() {
    echo "=== Menguji Path-Based Routing pada Gojo (jujutsu.k37.com) ==="
    echo "--- 1. Request ke Root Path (/) [Harus dibalas oleh Maki / Panda] ---"
    for i in 1 2 3 4; do
        curl -s http://jujutsu.k37.com/ | tr '\n' ' '
        echo ""
    done

    echo "--- 2. Request ke API Path (/api) [Harus diteruskan ke Geto -> Nanami / Todo] ---"
    for i in 1 2 3 4; do
        curl -s http://jujutsu.k37.com/api | tr '\n' ' '
        echo ""
    done
}

case "${1:-}" in
    test)
        test_routing
        ;;
    *)
        echo "Penggunaan: $0 test"
        exit 1
        ;;
esac
