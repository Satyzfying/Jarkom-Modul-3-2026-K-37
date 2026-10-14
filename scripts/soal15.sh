#!/bin/sh
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 15
# KELOMPOK 37 (K-37) - 2026
# Load Balancer Internal Geto (Weighted Round Robin 3:1: nanami vs todo)
# ==============================================================================

test_load_balancing() {
    echo "=== Menguji Distribusi Beban Weighted Round Robin (Target 3:1) ==="
    TOTAL=40
    NANAMI=0
    TODO=0

    echo "Mengirimkan $TOTAL request ke Geto (http://10.82.4.2/)..."
    for i in $(seq 1 $TOTAL); do
        RESP=$(curl -s http://10.82.4.2/)
        if echo "$RESP" | grep -q "nanami"; then
            NANAMI=$((NANAMI + 1))
        elif echo "$RESP" | grep -q "todo"; then
            TODO=$((TODO + 1))
        fi
    done

    echo "Hasil pengujian $TOTAL request:"
    echo " - Nanami (weight=3): $NANAMI request"
    echo " - Todo   (weight=1): $TODO request"
    
    RATIO=$(awk "BEGIN {printf \"%.2f\", $NANAMI / ($TODO > 0 ? $TODO : 1)}")
    echo "Rasio aktual Nanami:Todo = $RATIO : 1 (Teoritis 3:1)"
}

case "${1:-}" in
    test)
        test_load_balancing
        ;;
    *)
        echo "Penggunaan: $0 test"
        exit 1
        ;;
esac
