#!/bin/bash
# ==============================================================================
# PRAKTIKUM JARKOM MODUL 3 - SOAL 1
# KELOMPOK 37 (K-37) - 2026
# Prefix IP: 10.82.x.x
#
# Cara pakai:
# Buka console node yang diinginkan di GNS3, lalu copy-paste blok konfigurasi
# yang sesuai dengan nama nodenya.
# ==============================================================================

# ==============================================================================
# JICHI (Router Utama & DHCP Relay)
# ==============================================================================
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

# WAN terhubung ke NAT1
auto eth0
iface eth0 inet dhcp

# Gateway Network 1 (DMZ)
auto eth1
iface eth1 inet static
    address 10.82.1.1
    netmask 255.255.255.0

# Gateway Network 2 (Divisi A)
auto eth2
iface eth2 inet static
    address 10.82.2.1
    netmask 255.255.255.0

# Gateway Network 3 (Divisi B)
auto eth3
iface eth3 inet static
    address 10.82.3.1
    netmask 255.255.255.0

# Gateway Network 4 (Data Center)
auto eth4
iface eth4 inet static
    address 10.82.4.1
    netmask 255.255.255.0
EOF

service networking restart
udhcpc -i eth0 2>/dev/null

# Aktifkan IPv4 forwarding
sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

# Pasang aturan Source NAT (MASQUERADE)
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE

# Buat script pemeriksaan di /root/persiapan-jichi.sh
cat <<'EOF' > /root/persiapan-jichi.sh
#!/bin/bash
echo "=== Pemeriksaan Jichi ==="
echo "--- Interface ---"
ip -br addr
echo "--- Routing ---"
ip route
echo "--- IPv4 forwarding ---"
sysctl net.ipv4.ip_forward
echo "--- Source NAT ---"
iptables -t nat -L POSTROUTING -n -v
EOF
chmod +x /root/persiapan-jichi.sh
/root/persiapan-jichi.sh

# Auto-restore saat restart
grep -q "iptables -t nat" /root/.bashrc 2>/dev/null || cat <<'EOF' >> /root/.bashrc
udhcpc -i eth0 >/dev/null 2>&1
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
iptables -t nat -C POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE
EOF


# ==============================================================================
# NETWORK 1 (DMZ) - HOST INFRASTRUKTUR
# Gateway: 10.82.1.1 | DNS: 192.168.122.1
# ==============================================================================

# UTAHIME (DNS Master - 10.82.1.2)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.1.2
    netmask 255.255.255.0
    gateway 10.82.1.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# SHOKO (DNS Slave - 10.82.1.3)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.1.3
    netmask 255.255.255.0
    gateway 10.82.1.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# GOJO (Public Reverse Proxy - 10.82.1.4)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.1.4
    netmask 255.255.255.0
    gateway 10.82.1.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc


# ==============================================================================
# NETWORK 4 (DATA CENTER) - HOST INFRASTRUKTUR
# Gateway: 10.82.4.1 | DNS: 192.168.122.1
# ==============================================================================

# TENGEN (DHCP Server - 10.82.4.10)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.10
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# GETO (Internal Load Balancer - 10.82.4.2)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.2
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# MAKI (Worker Frontend - 10.82.4.3)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.3
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# PANDA (Worker Frontend - 10.82.4.4)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.4
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# NANAMI (Worker API Utama - 10.82.4.5)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.5
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# TODO (Worker API Utama - 10.82.4.6)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.6
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# KIRARA (Worker API Cadangan - 10.82.4.7)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.7
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# YAGA (Database Master - 10.82.4.8)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.8
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc

# INUMAKI (Database Slave - 10.82.4.9)
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.9
    netmask 255.255.255.0
    gateway 10.82.4.1
EOF
echo "nameserver 192.168.122.1" > /etc/resolv.conf
service networking restart
grep -q "nameserver 192.168.122.1" /root/.bashrc 2>/dev/null || echo 'echo "nameserver 192.168.122.1" > /etc/resolv.conf' >> /root/.bashrc


# ==============================================================================
# KLIEN NETWORK 2 (DIVISI A) & NETWORK 3 (DIVISI B) - DHCP
# itadori, fushiguro, zenin, okkotsu, ino, kusakabe, kugisaki, miwa
# ==============================================================================
cat <<'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
service networking restart
