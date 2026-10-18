#!/bin/bash

# ==== KUSAKABE (atau Klien lain) ====
apt-get update
apt-get install -y apache2-utils

# 1. Benchmark titik akhir Frontend Root
ab -n 600 -c 30 http://jujutsu.k37.com/

# 2. Benchmark titik akhir API Backend
ab -n 600 -c 30 http://jujutsu.k37.com/api
