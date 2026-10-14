# Jarkom-Modul-3-2026-K-37

| Nama | NRP |
|---|---|
| Azfaro Zid Ilmi | 5027251018 |
| Gede Satya Putra Aryanta | 5027251012 |

---

## Daftar Isi

- [Tabel Pembagian Interface & Alamat IP](#tabel-pembagian-interface--alamat-ip)
- [soal 1 - Satya & Azfaro](#soal-1---satya--azfaro)
- [soal 2 - Satya & Azfaro](#soal-2---satya--azfaro)
- [soal 3 - Satya & Azfaro](#soal-3---satya--azfaro)
- [soal 4 - Satya & Azfaro](#soal-4---satya--azfaro)
- [soal 5 - Satya & Azfaro](#soal-5---satya--azfaro)
- [soal 6 - Satya & Azfaro](#soal-6---satya--azfaro)
- [soal 7 - Satya & Azfaro](#soal-7---satya--azfaro)
- [soal 8 - Satya & Azfaro](#soal-8---satya--azfaro)
- [soal 9 - Satya & Azfaro](#soal-9---satya--azfaro)
- [soal 10 - Satya & Azfaro](#soal-10---satya--azfaro)

---

### Tabel Pembagian Interface & Alamat IP

Prefix ip : 10.82.x.x

| Node | Antarmuka | Alamat IP | Netmask | Gateway | Subnet / Keterangan |
|---|---|---|---|---|---|
| **jichi** | `eth0`<br>`eth1`<br>`eth2`<br>`eth3`<br>`eth4` | DHCP (NAT)<br>`10.82.1.1`<br>`10.82.2.1`<br>`10.82.3.1`<br>`10.82.4.1` | -<br>`255.255.255.0`<br>`255.255.255.0`<br>`255.255.255.0`<br>`255.255.255.0` | -<br>-<br>-<br>-<br>- | Router Utama & DHCP Relay<br>Gateway Network 1 (DMZ)<br>Gateway Network 2 (Divisi A)<br>Gateway Network 3 (Divisi B)<br>Gateway Network 4 (Data Center) |
| **utahime** | `eth0` | `10.82.1.2` | `255.255.255.0` | `10.82.1.1` | DNS Master (Network 1 - DMZ) |
| **shoko** | `eth0` | `10.82.1.3` | `255.255.255.0` | `10.82.1.1` | DNS Slave (Network 1 - DMZ) |
| **gojo** | `eth0` | `10.82.1.4` | `255.255.255.0` | `10.82.1.1` | Public Reverse Proxy Nginx (Network 1 - DMZ) |
| **itadori** | `eth0` | DHCP (`10.82.2.10` - `10.82.2.35`) | `255.255.255.0` | `10.82.2.1` | Klien Divisi A (DHCP Pool 1) |
| **fushiguro** | `eth0` | DHCP (`10.82.2.10` - `10.82.2.35`) | `255.255.255.0` | `10.82.2.1` | Klien Divisi A (DHCP Pool 1) |
| **zenin** | `eth0` | DHCP (`10.82.2.70` - `10.82.2.95`) | `255.255.255.0` | `10.82.2.1` | Klien Divisi A (DHCP Pool 2) |
| **okkotsu** | `eth0` | DHCP (`10.82.2.70` - `10.82.2.95`) | `255.255.255.0` | `10.82.2.1` | Klien Divisi A (DHCP Pool 2) |
| **ino** | `eth0` | DHCP (`10.82.3.10` - `10.82.3.89`) | `255.255.255.0` | `10.82.3.1` | Klien Divisi B (DHCP Short Lease) |
| **kusakabe** | `eth0` | DHCP (`10.82.3.10` - `10.82.3.89`) | `255.255.255.0` | `10.82.3.1` | Klien Divisi B (DHCP Short Lease) |
| **kugisaki** | `eth0` | DHCP Fixed (`10.82.3.99`) | `255.255.255.0` | `10.82.3.1` | Klien Divisi B (VIP Fixed Address) |
| **miwa** | `eth0` | DHCP (`10.82.3.100` - `10.82.3.199`) | `255.255.255.0` | `10.82.3.1` | Klien Divisi B (DHCP Long Lease) |
| **geto** | `eth0` | `10.82.4.2` | `255.255.255.0` | `10.82.4.1` | Internal Load Balancer Nginx (Data Center) |
| **maki** | `eth0` | `10.82.4.3` | `255.255.255.0` | `10.82.4.1` | Worker Frontend Nginx (Data Center) |
| **panda** | `eth0` | `10.82.4.4` | `255.255.255.0` | `10.82.4.1` | Worker Frontend Nginx (Data Center) |
| **nanami** | `eth0` | `10.82.4.5` | `255.255.255.0` | `10.82.4.1` | Worker API Utama (Data Center) |
| **todo** | `eth0` | `10.82.4.6` | `255.255.255.0` | `10.82.4.1` | Worker API Utama (Data Center) |
| **kirara** | `eth0` | `10.82.4.7` | `255.255.255.0` | `10.82.4.1` | Worker API Cadangan (Data Center) |
| **yaga** | `eth0` | `10.82.4.8` | `255.255.255.0` | `10.82.4.1` | Database Master MariaDB (Data Center) |
| **inumaki** | `eth0` | `10.82.4.9` | `255.255.255.0` | `10.82.4.1` | Database Slave MariaDB (Data Center) |
| **tengen** | `eth0` | `10.82.4.10` | `255.255.255.0` | `10.82.4.1` | DHCP Server isc-dhcp-server (Data Center) |

---

# Laporan Praktikum Modul 3

## soal 1 - Satya & Azfaro

---

> Ketika Curtain menutup Shibuya, jalur komunikasi antar zona Jujutsu High terputus. Pulihkan konektivitas dasar dengan mengonfigurasi jichi: eth0 memperoleh WAN dari NAT, sedangkan eth1–eth4 menjadi gateway Network 1–4 sesuai tabel pemetaan. Aktifkan IPv4 forwarding dan source NAT, lalu tetapkan IP statis host infrastruktur sesuai tabel spesifikasi. Buktikan konektivitas setiap host ke gateway dan akses eksternal dari host yang relevan.

### Maksud dari Soal No. 1

Tujuan dari soal ini adalah untuk melakukan konfigurasi jaringan dasar pada semua node agar bisa saling terhubung dan memiliki akses ke internet. Ini adalah langkah fondasi yang krusial agar kita bisa mengunduh dan menginstall paket-paket yang diperlukan di soal-soal berikutnya (seperti `isc-dhcp-server`, `bind9`, `nginx`, `mariadb-server`, dll.).

Sebelumnya kita buat dahulu topologi yang diminta:

![Topologi Jaringan Modul 3](assets/1-topology.png)

Pada nomor 1 ini kita diminta membangun topologi sesuai gambar rancangan di modul dan mengonfigurasi IP statis beserta default gateway untuk seluruh node infrastruktur yang ada di jaringan, mengaktifkan IPv4 forwarding, serta memasang Source NAT Masquerade pada router `jichi`.

Konfigurasi antarmuka disimpan di `/etc/network/interfaces` pada masing-masing node. 

Seluruh konfigurasi nomor 1 ini sudah kami kumpulkan di [`scripts/soal1.sh`](scripts/soal1.sh).

**Cara pakai script:**
1. Buka console **jichi** di GNS3, lalu copy-paste blok kode di bawah `# JICHI (Router Utama & DHCP Relay)` yang ada di `scripts/soal1.sh` (isinya konfigurasi interface `eth0` s/d `eth4`, IP forwarding, serta iptables Source NAT), kemudian jalankan `service networking restart`.
2. Buka console masing-masing host internal (`utahime`, `shoko`, `gojo`, `tengen`, `geto`, `maki`, `panda`, `nanami`, `todo`, `kirara`, `yaga`, `inumaki`), lalu copy-paste blok kode yang sesuai dengan nama nodenya di `scripts/soal1.sh` dan jalankan `service networking restart`.
3. Buka console masing-masing client (`itadori`, `fushiguro`, `zenin`, `okkotsu`, `ino`, `kusakabe`, `kugisaki`, `miwa`), lalu copy-paste blok kode client di `scripts/soal1.sh`.

Contoh config di `jichi`:
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.82.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.82.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.82.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.82.4.1
    netmask 255.255.255.0
```

Aktifkan penerusan paket (IPv4 forwarding) dan Source NAT pada `jichi`:
```bash
sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s 10.82.0.0/16 -o eth0 -j MASQUERADE
```

Contoh config di host infrastruktur (misal `tengen`):
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.82.4.10
    netmask 255.255.255.0
    gateway 10.82.4.1
```

Setiap host internal juga dipasang DNS sementara mengarah ke gateway NAT:
```bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

---

### Bukti Pengujian & Hasil Verifikasi

1. Bukti hasil pengecekan IP address (`ip -br addr`), routing (`ip route`), IPv4 forwarding (`sysctl net.ipv4.ip_forward`), dan aturan Source NAT Masquerade pada router `jichi`:
![Bukti Konfigurasi IP, Routing, Forwarding, dan NAT Jichi](assets/1-jichi-ip-routing-nat.png)

2. Bukti pengujian konektivitas ping gateway (`10.82.1.1` & `10.82.4.1`) serta ping dari router `jichi` ke host infrastruktur `tengen` (`10.82.4.10`):
![Bukti Pengujian Ping Gateway dan Host Tengen](assets/1-ping-gateway-tengen.png)

---

## soal 2 - Satya & Azfaro

---

> Tengen, penjaga pusat distribusi di Data Center, harus mengambil alih pengalokasian alamat bagi wilayah yang membutuhkan konfigurasi dinamis. Konfigurasikan isc-dhcp-server pada [PREFIX IP].4.10. Deklarasikan Network 4 ([PREFIX IP].4.0/24) sebagai subnet lokal tanpa pool dinamis, lalu siapkan scope DHCP untuk Network 2 ([PREFIX IP].2.0/24) dan Network 3 ([PREFIX IP].3.0/24). Validasi konfigurasi dan pastikan service aktif tanpa error “No subnet declaration”.

### Maksud dari Soal No. 2

Tujuan dari soal ini adalah mengonfigurasi node **tengen** (`10.82.4.10`) sebagai **DHCP Server** menggunakan paket `isc-dhcp-server`.
Beberapa poin penting pada konfigurasi ini:
1. **Deklarasi Subnet Lokal Network 4 (`10.82.4.0/24`)**: Karena antarmuka `eth0` milik `tengen` berada pada Network 4, daemon `dhcpd` mewajibkan adanya deklarasi subnet `10.82.4.0/24`. Dibuat blok subnet kosong tanpa pool dinamis (`range`) agar Network 4 tidak membagikan IP dinamis kepada host lokalnya. Hal ini mencegah terjadinya error **"No subnet declaration for eth0"**.
2. **Deklarasi Scope DHCP untuk Network 2 (`10.82.2.0/24`) dan Network 3 (`10.82.3.0/24`)**: Menyiapkan konfigurasi pool IP, gateway, netmask, serta DNS server bagi client di Divisi A dan Divisi B yang nantinya akan meminta IP melalui DHCP Relay `jichi`.
3. **Validasi Konfigurasi**: Memastikan tidak ada kesalahan sintaks pada `/etc/dhcp/dhcpd.conf` menggunakan `dhcpd -t` dan memastikan service `isc-dhcp-server` aktif mendengarkan permintaan di antarmuka `eth0`.

Seluruh konfigurasi nomor 2 ini sudah kami kumpulkan di [`scripts/soal2.sh`](scripts/soal2.sh).

**Cara pakai script:**
Buka console **tengen** di GNS3, lalu jalankan seluruh perintah berikut:

1. **Instalasi Paket `isc-dhcp-server`**:
```bash
apt-get update
apt-get install -y isc-dhcp-server
```

2. **Pengaturan Interface DHCP di `/etc/default/isc-dhcp-server`**:
```bash
cat <<'EOF' > /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF
```

3. **Konfigurasi DHCP Scope di `/etc/dhcp/dhcpd.conf`**:
```bash
cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Network 4: subnet lokal Tengen, tidak membagikan IP dinamis
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Network 2
subnet 10.82.2.0 netmask 255.255.255.0 {
    range 10.82.2.10 10.82.2.35;
    option routers 10.82.2.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}

# Network 3
subnet 10.82.3.0 netmask 255.255.255.0 {
    range 10.82.3.10 10.82.3.89;
    range 10.82.3.100 10.82.3.199;
    option routers 10.82.3.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}
EOF
```

4. **Validasi dan Pengujian Service**:
```bash
# Validasi sintaks file konfigurasi
dhcpd -t -cf /etc/dhcp/dhcpd.conf

# Restart service DHCP server
service isc-dhcp-server restart
service isc-dhcp-server status

# Memastikan autostart aktif
systemctl enable isc-dhcp-server 2>/dev/null || true
```

---

### Bukti Pengujian & Hasil Verifikasi

Bukti validasi sintaks konfigurasi menggunakan `dhcpd -t -cf /etc/dhcp/dhcpd.conf` serta pengetesan service DHCP server pada interface `eth0` yang berhasil aktif mendengarkan (*Listening on `LPF/eth0/.../10.82.4.0/24`*) tanpa adanya error *"No subnet declaration"*:

![Bukti Konfigurasi dan Validasi DHCP Server Tengen](assets/2-tengen-dhcp-server.png)


---

## soal 3 - Satya & Azfaro

---

> Permintaan alamat dari Divisi A dan Divisi B tidak dapat menyeberangi subnet secara langsung. Konfigurasikan jichi sebagai DHCP Relay menuju tengen ([PREFIX IP].4.10), menggunakan eth2 untuk Network 2 dan eth3 untuk Network 3. Buktikan bahwa client dari kedua subnet berhasil memperoleh lease melalui relay.

### Maksud dari Soal No. 3

Tujuan dari soal ini adalah mengonfigurasi router **jichi** sebagai **DHCP Relay** menggunakan paket `isc-dhcp-relay`.

Pada kondisi normal, permintaan konfigurasi jaringan oleh DHCP client dikirimkan menggunakan pesan broadcast UDP (port 67/68). Namun, router tidak meneruskan paket broadcast antar subnet. Karena server DHCP (**tengen**) berada di Network 4 (`10.82.4.10`), sedangkan client berada di Network 2 (Divisi A) dan Network 3 (Divisi B), dibutuhkan perantara yaitu DHCP Relay pada `jichi`.

DHCP Relay pada `jichi` bertugas:
1. Mendengarkan broadcast DHCP pada antarmuka client, yaitu `eth2` (Network 2) dan `eth3` (Network 3).
2. Meneruskan paket permintaan tersebut secara unicast ke DHCP Server `tengen` (`10.82.4.10`) melalui antarmuka gateway Network 4.
3. Meneruskan kembali balasan dari DHCP server ke client asal, sehingga client di Network 2 dan Network 3 berhasil mendapatkan alamat IP dinamis sesuai scope wilayahnya masing-masing.

Seluruh konfigurasi nomor 3 ini sudah kami kumpulkan di [`scripts/soal3.sh`](scripts/soal3.sh).

**Cara pakai script:**
1. Buka console **jichi** di GNS3, lalu pasang dan konfigurasikan `isc-dhcp-relay`:
```bash
# Update dan instalasi paket
apt-get update
apt-get install -y isc-dhcp-relay

# Konfigurasi relay server dan interface
cat <<'EOF' > /etc/default/isc-dhcp-relay
SERVERS="10.82.4.10"
INTERFACES="eth2 eth3"
OPTIONS=""
EOF

# Restart service relay
service isc-dhcp-relay restart
```
Atau dapat juga dijalankan secara foreground/debug interaktif:
```bash
dhcrelay -d -4 -i eth2 -i eth3 10.82.4.10
```

2. Buka console masing-masing client di Divisi A dan Divisi B (misal: `itadori`, `ino`, `kusakabe`), lalu jalankan perintah request lease DHCP:
```bash
/gns3/bin/udhcpc -f -n -q -i eth0
```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti DHCP Relay pada `jichi`**:
   Relay berhasil aktif mendengarkan antarmuka client `eth2` dan `eth3`, serta meneruskan paket `BOOTREQUEST` dari client menuju DHCP server `10.82.4.10`:
   ![Bukti DHCP Relay Jichi](assets/3-jichi-dhcrelay.png)

2. **Bukti Lease Client Divisi A (Network 2)**:
   Client `itadori` di Network 2 berhasil memperoleh IP `10.82.2.10` dari server `10.82.4.10`:
   ![Bukti Lease Client Itadori Network 2](assets/3-client-itadori-lease.png)

3. **Bukti Lease Client Divisi B (Network 3)**:
   Client di Network 3 (`ino` dan `kusakabe`) berhasil memperoleh IP dari scope Network 3:
   * `ino` memperoleh IP `10.82.3.12` dari server `10.82.4.10`:
   ![Bukti Lease Client Ino Network 3](assets/3-client-ino-lease.png)
   * `kusakabe` memperoleh IP `10.82.3.10` dari server `10.82.4.10`:
   ![Bukti Lease Client Kusakabe Network 3](assets/3-client-kusakabe-lease.png)


---

## soal 4 - Satya & Azfaro

---

> Agar tim Dev dan Support di Divisi A menerima jatah alamat yang berbeda, atur dua pool DHCP pada Network 2. Tetapkan Pool 1 ([PREFIX IP].2.10–[PREFIX IP].2.35) untuk itadori dan fushiguro, serta Pool 2 ([PREFIX IP].2.70–[PREFIX IP].2.95) untuk zenin dan okkotsu. Rentang [PREFIX IP].2.36–[PREFIX IP].2.69 tidak boleh dialokasikan. Karena seluruh client berada pada subnet yang sama, gunakan DHCP class berdasarkan MAC Address atau Client ID untuk memisahkan kedua kelompok.

### Maksud dari Soal No. 4

Tujuan dari soal ini adalah mengonfigurasi DHCP Server pada node **tengen** agar pembagian alamat IP dinamis pada Network 2 terbagi menjadi dua pool yang berbeda berdasarkan identitas masing-masing client (MAC Address):
1. **Tim Dev (`itadori` & `fushiguro`)**: Memperoleh IP dari **Pool 1** (`10.82.2.10` – `10.82.2.35`).
2. **Tim Support (`zenin` & `okkotsu`)**: Memperoleh IP dari **Pool 2** (`10.82.2.70` – `10.82.2.95`).
3. **Pemisahan Rentang (Excluded Range)**: Rentang IP `10.82.2.36` – `10.82.2.69` sengaja dikosongkan dan tidak boleh dialokasikan ke client mana pun.

Mekanisme yang digunakan adalah fitur `class` dan `pool` pada ISC DHCP Server dengan melakukan pencocokan hardware address (`substring(hardware, 1, 6)`).

---

### Langkah Konfigurasi

#### 1. Identifikasi MAC Address Client
Sebelum membuat class pada DHCP Server, kita periksa terlebih dahulu MAC address antarmuka `eth0` dari keempat client menggunakan perintah `ip link show eth0`:

| Client | Kelompok / Tim | MAC Address | Alokasi Pool IP |
|---|---|---|---|
| **itadori** | Dev | `02:42:ac:b6:01:00` | Pool 1 (`10.82.2.10` – `10.82.2.35`) |
| **fushiguro** | Dev | `02:42:05:ec:37:00` | Pool 1 (`10.82.2.10` – `10.82.2.35`) |
| **zenin** | Support | `02:42:43:4a:ba:00` | Pool 2 (`10.82.2.70` – `10.82.2.95`) |
| **okkotsu** | Support | `02:42:08:44:ea:00` | Pool 2 (`10.82.2.70` – `10.82.2.95`) |

#### 2. Konfigurasi DHCP Server di `tengen`
Seluruh konfigurasi nomor 4 ini sudah kami kumpulkan di [`scripts/soal4.sh`](scripts/soal4.sh).

Buka console **tengen** di GNS3, lalu edit `/etc/dhcp/dhcpd.conf` dengan menambahkan deklarasi `class "dev"` dan `class "support"` serta mendefinisikan kedua `pool` pada subnet Network 2:

```bash
cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Definisi Class Dev (Itadori & Fushiguro)
class "dev" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

# Definisi Class Support (Zenin & Okkotsu)
class "support" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

# Network 4: Subnet lokal Tengen (tanpa pool dinamis)
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Network 2: Subnet Divisi A dengan dua Pool terpisah
subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option domain-name-servers 8.8.8.8;

    # Pool 1 untuk Tim Dev (10.82.2.10 - 10.82.2.35)
    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "dev";
    }

    # Pool 2 untuk Tim Support (10.82.2.70 - 10.82.2.95)
    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "support";
    }
}

# Network 3: Subnet Divisi B
subnet 10.82.3.0 netmask 255.255.255.0 {
    range 10.82.3.10 10.82.3.89;
    range 10.82.3.100 10.82.3.199;
    option routers 10.82.3.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}
EOF

# Validasi dan restart service
dhcpd -t -cf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Konfigurasi Class dan Pool di `tengen`**:
   Potongan konfigurasi `class "dev"`, `class "support"`, dan pembagian `pool` pada file `/etc/dhcp/dhcpd.conf`:
   ![Bukti Konfigurasi Class dan Pool Tengen](assets/4-dhcp-class-pool-config.png)

2. **Bukti Pengecekan MAC Address Client**:
   Verifikasi nilai MAC Address fisik dari `itadori`, `fushiguro`, `zenin`, dan `okkotsu` menggunakan `ip link show eth0`:
   ![Bukti Pengecekan MAC Address Client](assets/4-client-mac-address.png)

3. **Bukti Pengujian Lease Keempat Client**:
   Masing-masing client meminta IP ke DHCP Server melalui perintah:
   ```bash
   /gns3/bin/udhcpc -f -n -q -i eth0
   ```
   ![Bukti Pengujian Lease Empat Client Divisi A](assets/4-client-lease-testing.png)

Tabel hasil perolehan IP oleh masing-masing client:

| Client | MAC Address | Alamat IP yang Diperoleh | Pool | Keterangan |
|---|---|---|---|---|
| **itadori** | `02:42:ac:b6:01:00` | `10.82.2.10` | Pool 1 | Sesuai rentang `10.82.2.10` – `10.82.2.35` |
| **fushiguro** | `02:42:05:ec:37:00` | `10.82.2.11` | Pool 1 | Sesuai rentang `10.82.2.10` – `10.82.2.35` |
| **zenin** | `02:42:43:4a:ba:00` | `10.82.2.71` | Pool 2 | Sesuai rentang `10.82.2.70` – `10.82.2.95` |
| **okkotsu** | `02:42:08:44:ea:00` | `10.82.2.70` | Pool 2 | Sesuai rentang `10.82.2.70` – `10.82.2.95` |

### Analisis Hasil
* `itadori` (`10.82.2.10`) dan `fushiguro` (`10.82.2.11`) berhasil masuk ke **Pool 1** karena MAC address keduanya terdaftar sebagai member dari `class "dev"`.
* `zenin` (`10.82.2.71`) dan `okkotsu` (`10.82.2.70`) berhasil masuk ke **Pool 2** karena MAC address keduanya terdaftar sebagai member dari `class "support"`.
* Tidak ada client yang mendapatkan IP pada rentang terlarang `10.82.2.36` – `10.82.2.69`.
* Pembagian alokasi pool DHCP berdasarkan MAC address pada Network 2 telah terbukti berhasil 100%.
## soal 5 - Satya & Azfaro

---

### Maksud dari Soal No. 5

Tujuan dari soal ini adalah mengatur alokasi durasi sewa (*lease time*) alamat IP pada Network 3 (Divisi B) berdasarkan klasifikasi client menggunakan mekanisme `class` dan `pool` pada ISC DHCP Server:
1. **Short Lease (30 menit / 1800 detik)**: Dialokasikan untuk client **ino** (MAC `02:42:0d:a8:e7:00`) dan **kusakabe** (MAC `02:42:10:fb:eb:00`) menggunakan pool IP `10.82.3.10` – `10.82.3.89`.
2. **Long Lease (12 jam / 43200 detik)**: Dialokasikan untuk client **miwa** (MAC `02:42:df:12:4b:00`) menggunakan pool IP `10.82.3.100` – `10.82.3.199`.
3. **DHCP Options**: Setiap client di Network 3 harus menerima konfigurasi DNS Server `10.82.1.2` dan `10.82.1.3` (DNS Master Utahime & DNS Slave Shoko di DMZ), serta opsi pencarian domain (*domain-search*) `"k37.com"`.

---

### Langkah Konfigurasi

Seluruh konfigurasi nomor 5 ini sudah kami kumpulkan di [`scripts/soal5.sh`](scripts/soal5.sh).

Buka console **tengen** di GNS3, lalu perbarui file konfigurasi `/etc/dhcp/dhcpd.conf`:

```bash
cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Class Network 2 (Divisi A)
class "dev" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

class "support" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

# Class Network 3 (Divisi B)
class "short_lease" {
    match if
        substring(hardware, 1, 6) = 02:42:0d:a8:e7:00 or
        substring(hardware, 1, 6) = 02:42:10:fb:eb:00;
}

class "long_lease" {
    match if substring(hardware, 1, 6) = 02:42:df:12:4b:00;
}

# Subnet Network 4: Lokal Tengen (tanpa pool dinamis)
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Subnet Network 2: Divisi A
subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "dev";
    }

    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "support";
    }
}

# Subnet Network 3: Divisi B dengan Short Lease dan Long Lease
subnet 10.82.3.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.3.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    # Pool Short Lease (1800 detik / 30 menit)
    pool {
        range 10.82.3.10 10.82.3.89;
        allow members of "short_lease";
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Pool Long Lease (43200 detik / 12 jam)
    pool {
        range 10.82.3.100 10.82.3.199;
        allow members of "long_lease";
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

# Validasi dan restart service DHCP Server
dhcpd -t -cf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Konfigurasi Class dan Lease Time di `tengen`**:
   Potongan konfigurasi `class "short_lease"`, `class "long_lease"`, dan pengaturan pool durasi lease pada `/etc/dhcp/dhcpd.conf`:
   ![Konfigurasi Class dan Lease Time Network 3](assets/5-dhcp-class-lease-config.png)

2. **Bukti Pengujian Lease Klien Divisi B**:
   Masing-masing client di Divisi B meminta lease alamat IP melalui perintah:
   ```bash
   /gns3/bin/udhcpc -f -n -q -i eth0
   ```
   ![Hasil Pengujian Lease Klien Network 3](assets/5-client-lease-testing.png)

Tabel hasil perolehan lease alamat IP klien Divisi B:

| Client | MAC Address | IP Address Diperoleh | Durasi Lease Aktual | Target Lease | Pool Alokasi | Status |
|---|---|---|---|---|---|---|
| **ino** | `02:42:0d:a8:e7:00` | `10.82.3.12` | 1786 detik | 1800 detik (30 mnt) | `10.82.3.10` – `10.82.3.89` | Berhasil (Short Lease) |
| **kusakabe** | `02:42:10:fb:eb:00` | `10.82.3.10` | 1739 detik | 1800 detik (30 mnt) | `10.82.3.10` – `10.82.3.89` | Berhasil (Short Lease) |
| **miwa** | `02:42:df:12:4b:00` | `10.82.3.100` | 43168 detik | 43200 detik (12 jam) | `10.82.3.100` – `10.82.3.199` | Berhasil (Long Lease) |

### Analisis Hasil & Kesimpulan
* Klien `ino` dan `kusakabe` berhasil mendapatkan alamat IP dari pool short lease (`10.82.3.12` dan `10.82.3.10`) dengan masa aktif sewa ~1800 detik.
* Klien `miwa` berhasil mendapatkan IP dari pool long lease (`10.82.3.100`) dengan masa aktif sewa ~43200 detik.
* Nilai lease time aktual yang tercatat pada klien sedikit di bawah nilai target karena selisih beberapa detik pada waktu handshake dan inisialisasi antarmuka klien.
* Pemisahan durasi sewa berdasarkan kelas client pada Network 3 berhasil diimplementasikan dengan sempurna.

---

### Soal No. 5
> Setiap tim lapangan memiliki durasi operasi yang berbeda. Pada Network 3, berikan short lease 30 menit (1800 detik) kepada ino dan kusakabe, serta long lease 12 jam (43200 detik) kepada miwa. Gunakan pool short lease [PREFIX IP].3.10–[PREFIX IP].3.89 dan pool long lease [PREFIX IP].3.100–[PREFIX IP].3.199. Sesuaikan default-lease-time dan max-lease-time untuk setiap kelas client. Berikan pula DHCP options berupa DNS [PREFIX IP].1.2 dan [PREFIX IP].1.3, serta domain-search <xxxx>.com.

---

## soal 6 - Satya & Azfaro

---

### Maksud dari Soal No. 6

Tujuan dari soal ini adalah menetapkan konfigurasi **DHCP Static Lease** (*reservasi fixed IP*) kepada personel VIP yaitu client **kugisaki**:
1. Menetapkan alamat IP tetap `10.82.3.99` berdasarkan MAC Address antarmuka `eth0` milik Kugisaki (`02:42:fc:2c:59:00`).
2. Memastikan alamat reservasi `10.82.3.99` berada di luar rentang seluruh pool dinamis Network 3 (`10.82.3.10`–`10.82.3.89` dan `10.82.3.100`–`10.82.3.199`) agar tidak ada bentrok atau interferensi IP (*IP collision*).
3. Memvalidasi sintaks konfigurasi pada server Tengen dan melakukan *renew lease* pada client Kugisaki untuk membuktikan bahwa alamat yang diterima selalu `10.82.3.99`.

---

### Langkah Konfigurasi

Seluruh konfigurasi nomor 6 ini sudah kami kumpulkan di [`scripts/soal6.sh`](scripts/soal6.sh).

Buka console **tengen** di GNS3, lalu tambahkan deklarasi `host kugisaki` pada file `/etc/dhcp/dhcpd.conf`:

```bash
cat <<'EOF' > /etc/dhcp/dhcpd.conf
authoritative;
default-lease-time 600;
max-lease-time 7200;

# Class Network 2 (Divisi A)
class "dev" {
    match if
        substring(hardware, 1, 6) = 02:42:ac:b6:01:00 or
        substring(hardware, 1, 6) = 02:42:05:ec:37:00;
}

class "support" {
    match if
        substring(hardware, 1, 6) = 02:42:43:4a:ba:00 or
        substring(hardware, 1, 6) = 02:42:08:44:ea:00;
}

# Class Network 3 (Divisi B)
class "short_lease" {
    match if
        substring(hardware, 1, 6) = 02:42:0d:a8:e7:00 or
        substring(hardware, 1, 6) = 02:42:10:fb:eb:00;
}

class "long_lease" {
    match if substring(hardware, 1, 6) = 02:42:df:12:4b:00;
}

# Subnet Network 4: Lokal Tengen
subnet 10.82.4.0 netmask 255.255.255.0 {
}

# Subnet Network 2: Divisi A
subnet 10.82.2.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.2.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    pool {
        range 10.82.2.10 10.82.2.35;
        allow members of "dev";
    }

    pool {
        range 10.82.2.70 10.82.2.95;
        allow members of "support";
    }
}

# Subnet Network 3: Divisi B
subnet 10.82.3.0 netmask 255.255.255.0 {
    option subnet-mask 255.255.255.0;
    option routers 10.82.3.1;
    option domain-name-servers 10.82.1.2, 10.82.1.3;
    option domain-search "k37.com";

    # Static Lease untuk Personal VIP Kugisaki
    host kugisaki {
        hardware ethernet 02:42:fc:2c:59:00;
        fixed-address 10.82.3.99;
    }

    # Pool 1: Short Lease
    pool {
        range 10.82.3.10 10.82.3.89;
        allow members of "short_lease";
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Pool 2: Long Lease
    pool {
        range 10.82.3.100 10.82.3.199;
        allow members of "long_lease";
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

# Validasi sintaks konfigurasi server
dhcpd -t -cf /etc/dhcp/dhcpd.conf

# Restart service DHCP server
service isc-dhcp-server restart
```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Validasi Sintaks Konfigurasi di Server `tengen`**:
   Hasil pengujian validasi sintaks `/etc/dhcp/dhcpd.conf` menggunakan perintah `dhcpd -t -cf /etc/dhcp/dhcpd.conf` yang berjalan bersih tanpa ada error:
   ![Validasi Konfigurasi DHCP Server Tengen](assets/6-dhcp-static-lease-config.png)

2. **Bukti Pengujian Static Lease Klien `kugisaki`**:
   Verifikasi nilai MAC Address (`02:42:fc:2c:59:00`) pada `kugisaki` serta eksekusi pembaruan lease DHCP:
   ```bash
   ip a | grep ether
   /gns3/bin/udhcpc -f -n -q -i eth0
   ```
   ![Hasil Uji Static Lease Klien Kugisaki](assets/6-client-kugisaki-static-lease.png)

Tabel hasil alokasi static lease Kugisaki:

| Parameter | Nilai Konfigurasi / Hasil |
|---|---|
| **Node Client** | `kugisaki` (VIP Personnel) |
| **MAC Address Antarmuka `eth0`** | `02:42:fc:2c:59:00` |
| **Alamat IP Reservasi** | `10.82.3.99` |
| **DHCP Server Pemberi Lease** | `10.82.4.10` (Tengen) |
| **Default Gateway** | `10.82.3.1` (Jichi) |
| **Status Pool** | Di luar pool dinamis (`.10–.89` & `.100–.199`) |

### Analisis Hasil & Kesimpulan
* Deklarasi `host kugisaki` dengan parameter `fixed-address 10.82.3.99` berhasil mengenali hardware ethernet `02:42:fc:2c:59:00`.
* Saat klien melakukan request DHCP lease, server langsung memberikan IP reservasi `10.82.3.99` tanpa melalui alokasi pool dinamis.
* Alamat `10.82.3.99` terisolasi dari pool short lease maupun long lease, sehingga keunikan IP bagi personel VIP terjamin.

---

### Soal No. 6
> Kugisaki ditetapkan sebagai personel VIP yang harus mempertahankan alamat yang sama setiap kali terhubung. Buat DHCP static lease berdasarkan MAC Address client tersebut dengan fixed address [PREFIX IP].3.99. Pastikan alamat ini berada di luar seluruh pool dinamis, validasi konfigurasi server, lalu renew lease pada client. Buktikan bahwa alamat yang diterima sesuai dengan reservasi.

---

## soal 7 - Satya & Azfaro

---

### Maksud dari Soal No. 7

Tujuan dari soal ini adalah memverifikasi secara menyeluruh bahwa seluruh client di Divisi A (Network 2) dan Divisi B (Network 3) telah menerima parameter konfigurasi jaringan yang lengkap dan benar sesuai wilayah subnetnya masing-masing:
1. **Subnet Mask**: `255.255.255.0` (`/24`) untuk semua client.
2. **Default Gateway & Broadcast**:
   - Divisi A: Gateway `10.82.2.1` dan Broadcast `10.82.2.255`.
   - Divisi B: Gateway `10.82.3.1` dan Broadcast `10.82.3.255`.
3. **DNS Server**: Menerima DNS Master Utahime (`10.82.1.2`) dan DNS Slave Shoko (`10.82.1.3`).
4. **Domain Search**: Mengarah ke domain `"k37.com"`.
5. **Verifikasi Database Lease Server Tengen**: Memeriksa file `/var/lib/dhcp/dhcpd.leases` untuk memastikan tidak ada alokasi IP yang bentrok (*IP conflict*) atau berada di luar kebijakan pool yang telah ditetapkan.

---

### Langkah Konfigurasi & Verifikasi

Seluruh prosedur verifikasi nomor 7 ini sudah kami kumpulkan di [`scripts/soal7.sh`](scripts/soal7.sh).

1. **Pemeriksaan Opsi Subnet pada Server Tengen**:
   ```bash
   grep -A 8 'subnet 10.82.2.0' /etc/dhcp/dhcpd.conf
   grep -A 8 'subnet 10.82.3.0' /etc/dhcp/dhcpd.conf
   ```

2. **Pemeriksaan Parameter pada Klien**:
   Jalankan perintah berikut pada setiap node klien:
   ```bash
   ip -4 addr show eth0
   ip route
   cat /etc/resolv.conf
   ```

3. **Pemeriksaan Database Lease pada Tengen**:
   ```bash
   tail -n 100 /var/lib/dhcp/dhcpd.leases
   awk '/^lease 10\.82\.[23]\./ {ip=$2} /hardware ethernet/ {print ip, $3}' /var/lib/dhcp/dhcpd.leases
   ```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Konfigurasi Opsi DHCP Subnet Network 2 di Server `tengen`**:
   Verifikasi pengaturan subnet mask, default gateway, DNS server ganda, dan domain search pada file `/etc/dhcp/dhcpd.conf`:
   ![Konfigurasi DHCP Options Network 2 di Tengen](assets/7-tengen-dhcp-options-config.png)

2. **Bukti Verifikasi Jaringan pada Client Divisi A dan Divisi B**:
   Pengujian perintah `ip -4 addr show eth0`, `ip route`, dan `cat /etc/resolv.conf` pada node klien (`ino`, `kusakabe`, `itadori`, `fushiguro`):
   ![Verifikasi Konfigurasi Jaringan Klien](assets/7-client-network-verification.png)

3. **Bukti Verifikasi DNS Resolver pada Klien Divisi A**:
   Tampilan isi `/etc/resolv.conf` pada `itadori` dan `fushiguro` yang mengonfirmasi penerimaan search domain `k37.com` dan nameserver `10.82.1.2` serta `10.82.1.3`:
   ![Verifikasi DNS Resolver Client Divisi A](assets/7-client-resolv-conf.png)

4. **Bukti Pencocokan Catatan Lease pada Database Server `tengen`**:
   Pemeriksaan file `/var/lib/dhcp/dhcpd.leases` membuktikan seluruh lease aktif cocok dengan MAC address klien yang terdaftar:
   ![Daftar Catatan Lease Aktif pada Tengen](assets/7-dhcp-leases-verification.png)
   ![Detail Riwayat Lease Database Tengen](assets/7-dhcpd-leases-details.png)

Tabel rangkuman verifikasi konfigurasi jaringan seluruh klien:

| Klien | Divisi / Network | Alamat IP | Subnet Mask | Gateway | DNS Servers | Domain Search | Status Alokasi |
|---|---|---|---|---|---|---|---|
| **itadori** | Divisi A (Net 2) | `10.82.2.10` | `/24` | `10.82.2.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Pool 1 (Dev) |
| **fushiguro** | Divisi A (Net 2) | `10.82.2.11` | `/24` | `10.82.2.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Pool 1 (Dev) |
| **zenin** | Divisi A (Net 2) | `10.82.2.71` | `/24` | `10.82.2.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Pool 2 (Support) |
| **okkotsu** | Divisi A (Net 2) | `10.82.2.70` | `/24` | `10.82.2.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Pool 2 (Support) |
| **ino** | Divisi B (Net 3) | `10.82.3.12` | `/24` | `10.82.3.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Short Lease |
| **kusakabe** | Divisi B (Net 3) | `10.82.3.10` | `/24` | `10.82.3.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Short Lease |
| **kugisaki** | Divisi B (Net 3) | `10.82.3.99` | `/24` | `10.82.3.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Static Lease VIP |
| **miwa** | Divisi B (Net 3) | `10.82.3.100` | `/24` | `10.82.3.1` | `10.82.1.2`, `10.82.1.3` | `k37.com` | Sesuai Long Lease |

### Analisis Hasil & Kesimpulan
* Seluruh client di Divisi A dan Divisi B memperoleh konfigurasi jaringan yang lengkap, valid, dan konsisten dengan topologi.
* Pengecekan pada database `/var/lib/dhcp/dhcpd.leases` membuktikan bahwa setiap IP dipetakan tepat ke MAC address pemiliknya.
* Tidak ditemukan adanya alamat IP yang tumpang tindih (*collision*) maupun alamat yang keluar dari batas rentang pool yang ditentukan.

---

### Soal No. 7
> Setelah aturan alokasi diterapkan, pastikan setiap client menerima konfigurasi jaringan sesuai wilayahnya: subnet mask 255.255.255.0 (/24), gateway dan broadcast address yang benar, DNS [PREFIX IP].1.2 serta [PREFIX IP].1.3, dan domain-search yang ditentukan. Periksa IP address dan routing seluruh client Divisi A dan Divisi B, kemudian cocokkan lease dengan /var/lib/dhcp/dhcpd.leases pada tengen. Pastikan tidak ada alamat yang bertabrakan atau berada di luar kebijakan pool.

---

## soal 8 - Satya & Azfaro

---

### Maksud dari Soal No. 8

Tujuan dari soal ini adalah membuktikan keabsahan proses pemberian alamat IP dinamis yang melintasi beberapa subnet berjalan sesuai dengan spesifikasi protokol DHCP melalui **DHCP Relay** router Jichi:
1. Memverifikasi 4 urutan pertukaran paket DHCP (**DORA**):
   - **DHCPDISCOVER** (Client $\to$ Broadcast / Relay)
   - **DHCPOFFER** (Server $\to$ Relay $\to$ Client)
   - **DHCPREQUEST** (Client $\to$ Relay $\to$ Server)
   - **DHCPACK** (Server $\to$ Relay $\to$ Client)
2. Mengidentifikasi parameter penting dalam komunikasi DHCP:
   - Alamat DHCP Server: `10.82.4.10` (Tengen).
   - Alamat IP yang dialokasikan: `10.82.3.100` (untuk client Miwa).
   - Durasi Lease Time: `38388` detik (Long Lease).
   - Nilai field **`giaddr`** (*Gateway IP Address*): `10.82.3.1`, yang membuktikan bahwa request berasal dari antarmuka `eth3` milik router Jichi yang melayani subnet Network 3.

---

### Langkah Pengujian Protokol DHCP (DORA)

Seluruh instruksi pengujian nomor 8 ini sudah kami kumpulkan di [`scripts/soal8.sh`](scripts/soal8.sh).

1. **Monitoring pada DHCP Server Tengen**:
   Pantau log daemon dhcpd atau jalankan packet capture dengan tcpdump:
   ```bash
   tcpdump -i eth0 -n -vvv port 67 or port 68
   # atau amati log aktivitas daemon:
   tail -f /var/log/syslog | grep -E 'DHCPDISCOVER|DHCPOFFER|DHCPREQUEST|DHCPACK'
   ```

2. **Monitoring pada Router Jichi (DHCP Relay)**:
   Jalankan `dhcrelay` secara foreground untuk melihat penanganan field `giaddr`:
   ```bash
   dhcrelay -d -4 -i eth2 -i eth3 10.82.4.10
   ```

3. **Eksekusi Request Lease pada Client (Miwa)**:
   ```bash
   /gns3/bin/udhcpc -i eth0 -n -q
   ```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Urutan Paket DORA dan Field `giaddr` pada Server `tengen`**:
   Tangkapan layar log server Tengen memperlihatkan secara jelas keempat tahapan paket DHCP serta nilai `giaddr` `10.82.3.1`:
   ![Urutan Paket DHCP DORA dan giaddr pada Log Server Tengen](assets/8-packet-capture-dhcp-relay.png)

2. **Bukti Hasil Eksekusi Lease pada Client `miwa`**:
   Terminal `miwa` memperlihatkan proses perolehan IP `10.82.3.100` dari server `10.82.4.10` dengan masa lease `38388` detik:
   ![Hasil Eksekusi Lease DHCP pada Client Miwa](assets/8-client-dhcp-lease.png)

3. **Bukti Log DHCP Relay `jichi` Menampilkan Field `giaddr`**:
   Router Jichi meneruskan paket balasan (*BOOTREPLY*) dengan menyertakan informasi `giaddr: 10.82.2.1` dan `10.82.4.1` menuju host asal:
   ![Log DHCP Relay Jichi Menampilkan giaddr](assets/8-jichi-relay-giaddr.png)

### Analisis Rinci Alur Pertukaran Protokol DHCP (DORA)

Berdasarkan bukti tangkapan paket di atas, berikut analisis mendalam mengenai setiap tahap transaksi DHCP:

1. **Tahap 1 — DHCPDISCOVER**:
   - Klien `miwa` mengirimkan paket broadcast pencarian server DHCP.
   - Karena siaran broadcast tidak dapat melewati batas router, router `jichi` menangkap paket tersebut di antarmuka `eth3` (`10.82.3.1`), menyisipkan alamat IP antarmukanya ke dalam field `giaddr = 10.82.3.1`, dan meneruskannya secara unicast ke server `tengen` (`10.82.4.10`).
   - Log server mencatat: `DHCPDISCOVER from 02:42:df:12:4b:00 via 10.82.3.1`.

2. **Tahap 2 — DHCPOFFER**:
   - Server `tengen` membaca nilai `giaddr = 10.82.3.1` dan menyimpulkan bahwa klien berada di Network 3.
   - Karena MAC address klien cocok dengan `class "long_lease"`, server menawarkan alamat IP dari pool long lease yaitu `10.82.3.100`.
   - Paket tawaran dikirim kembali ke relay `10.82.3.1`.
   - Log server mencatat: `DHCPOFFER on 10.82.3.100 to 02:42:df:12:4b:00 via 10.82.3.1`.

3. **Tahap 3 — DHCPREQUEST**:
   - Klien `miwa` menerima tawaran dan mengajukan permohonan resmi untuk menggunakan IP `10.82.3.100` kepada server `10.82.4.10`.
   - Paket diteruskan kembali melalui relay `jichi` dengan `giaddr = 10.82.3.1`.
   - Log server mencatat: `DHCPREQUEST for 10.82.3.100 (10.82.4.10) from 02:42:df:12:4b:00 via 10.82.3.1`.

4. **Tahap 4 — DHCPACK**:
   - Server `tengen` mencatat penyewaan IP ke dalam database lease dan mengirimkan paket konfirmasi (`DHCPACK`) beserta opsi jaringan (mask, gateway, DNS, lease duration).
   - Log server mencatat: `DHCPACK on 10.82.3.100 to 02:42:df:12:4b:00 via 10.82.3.1`.
   - Klien menerima konfirmasi dan mengonfigurasi interface `eth0` dengan IP `10.82.3.100` serta masa sewa `38388` detik.

---

### Soal No. 8
> Sebelum Curtain dibuka kembali, buktikan bahwa proses pemberian alamat berjalan sesuai protokol. Lakukan packet capture saat salah satu client Network 2 atau Network 3 meminta lease baru. Gunakan tcpdump pada tengen atau jalur menuju Data Center untuk menunjukkan urutan DHCPDISCOVER → DHCPOFFER → DHCPREQUEST → DHCPACK. Identifikasi alamat server, alamat yang diberikan, lease time, dan field giaddr. Pastikan nilai giaddr sesuai dengan interface jichi yang menerima request dari subnet client.

---

## soal 9 - Satya & Azfaro

---

### Maksud dari Soal No. 9

Tujuan dari soal ini adalah melakukan simulasi gangguan jaringan (*fault tolerance & failure simulation*) dengan mematikan service DHCP Relay pada router `jichi`:
1. **Simulasi Gangguan**: Menghentikan daemon `isc-dhcp-relay` pada router Jichi, kemudian memaksa client meminta lease baru dan mengamati gejala kegagalannya.
2. **Analisis Gejala**: Membuktikan bahwa paket broadcast discovery dari client tidak dapat mencapai Data Center (server Tengen) sehingga client mengalami kegagalan sewa (*DHCP lease timeout*).
3. **Pemulihan Layanan**: Menghidupkan kembali service DHCP Relay pada router Jichi, mengulangi permintaan lease pada client, dan membuktikan bahwa client berhasil memperoleh kembali konfigurasi IP dari pool yang benar beserta gateway asalnya.

---

### Langkah Simulasi Gangguan dan Pemulihan

Seluruh perintah simulasi nomor 9 ini sudah kami kumpulkan di [`scripts/soal9.sh`](scripts/soal9.sh).

#### Fase 1: Simulasi Gangguan (Relay Mati)
1. Pada console router **jichi**, hentikan service DHCP Relay:
   ```bash
   service isc-dhcp-relay stop
   killall dhcrelay 2>/dev/null || true
   ```
2. Pada console client **miwa** (Network 3), paksa permintaan lease baru:
   ```bash
   /gns3/bin/udhcpc -i eth0 -n -q
   ```

#### Fase 2: Pemulihan Layanan (Relay Aktif Kembali)
1. Pada console router **jichi**, jalankan kembali service DHCP Relay:
   ```bash
   service isc-dhcp-relay start
   ```
2. Pada console client **miwa**, ulangi permintaan lease:
   ```bash
   /gns3/bin/udhcpc -i eth0 -n -q
   ```

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Gejala Kegagalan saat DHCP Relay Dihentikan**:
   Ketika relay di Jichi dimatikan, permintaan `udhcpc` pada client `miwa` mengalami kegagalan total:
   ![Gejala Kegagalan Lease saat Relay Dihentikan](assets/9-dhcp-relay-failure.png)

   **Gejala yang diamati:**
   - Klien mengirimkan pesan `broadcasting discover` berkali-kali tanpa adanya jawaban `DHCPOFFER`.
   - Setelah melampaui batas waktu tunggu (*timeout*), `udhcpc` mengeluarkan pesan error:
     ```
     udhcpc: broadcasting discover
     udhcpc: broadcasting discover
     udhcpc: broadcasting discover
     udhcpc failed to get a DHCP lease
     udhcpc: no lease, failing
     ```

2. **Bukti Pemulihan Layanan Setelah DHCP Relay Dijalankan Kembali**:
   Perbandingan langsung pada terminal client `miwa` sebelum dan sesudah service DHCP Relay dipulihkan:
   ![Perbandingan Kegagalan dan Pemulihan DHCP Relay](assets/9-dhcp-relay-recovery.png)

   **Hasil setelah pemulihan:**
   - Begitu service DHCP Relay di Jichi diaktifkan kembali, permintaan sewa pada `miwa` langsung direspons seketika oleh server Tengen:
     ```
     udhcpc: broadcasting discover
     udhcpc: broadcasting select for 10.82.3.100, server 10.82.4.10
     udhcpc: lease of 10.82.3.100 obtained from 10.82.4.10, lease time 38128
     ```
   - Klien `miwa` kembali memperoleh alamat IP yang tepat (`10.82.3.100`) dari pool long lease Network 3 dengan default gateway semula (`10.82.3.1`).

### Analisis Hasil & Kesimpulan
* Percobaan ini membuktikan ketergantungan mutlak komunikasi DHCP multi-subnet terhadap ketersediaan DHCP Relay agent pada default gateway.
* Ketika relay terputus, paket broadcast discovery tidak memiliki jalur untuk menembus batasan router menuju server DHCP di Data Center.
* Begitu relay dipulihkan, sistem jaringan secara otomatis kembali beroperasi secara normal tanpa memerlukan konfigurasi ulang manual pada sisi klien maupun server.

---

### Soal No. 9
> Sebuah gangguan memutus jalur relay dan membuat permintaan alamat tidak sampai ke Data Center. Hentikan service DHCP Relay pada jichi, lalu paksa salah satu client di Network 2 atau Network 3 meminta lease baru dan catat gejalanya. Pulihkan service relay, ulangi permintaan DHCP, lalu buktikan bahwa client kembali memperoleh alamat dari pool yang benar dengan gateway semula.

## soal 10 - Satya & Azfaro

---

### Maksud dari Soal No. 10

Tujuan dari soal ini adalah memastikan bahwa seluruh infrastruktur layanan DHCP yang telah dibangun bertahan (*persistent*) dan berjalan otomatis (*autostart*) setelah sistem dimulai ulang (*reboot / restart*):
1. **Autostart DHCP Server di Tengen**: Memastikan service `isc-dhcp-server` aktif secara otomatis saat boot pada runlevel sistem tanpa intervensi manual.
2. **Autostart DHCP Relay di Jichi**: Memastikan proses `dhcrelay` berjalan otomatis saat router Jichi di-restart dengan mendengarkan antarmuka client (`eth2` dan `eth3`) serta antarmuka uplink Data Center (`eth4`) menuju DHCP server (`10.82.4.10`). Mekanisme autostart dibuat tangguh menggunakan init script (`/etc/init.d/dhcrelay-custom`) dan pemicu startup `/etc/rc.local`.
3. **Uji Restart & Validasi Menyeluruh**: Memulai ulang kedua node (Tengen dan Jichi), lalu memverifikasi status layanan, ketersediaan proses, dan memastikan seluruh kebijakan alokasi IP yang telah dikonfigurasi sebelumnya tetap berlaku penuh:
   - **Pool 1 (Dev)**: `itadori` & `fushiguro` (`10.82.2.10` – `10.82.2.35`).
   - **Pool 2 (Support)**: `zenin` & `okkotsu` (`10.82.2.70` – `10.82.2.95`).
   - **Short Lease**: `ino` & `kusakabe` (1800 detik, `10.82.3.10` – `10.82.3.89`).
   - **Long Lease**: `miwa` (43200 detik, `10.82.3.100` – `10.82.3.199`).
   - **Static Lease Fixed IP**: `kugisaki` (`10.82.3.99`).

---

### Langkah Konfigurasi & Implementasi Autostart

Seluruh konfigurasi nomor 10 ini sudah kami kumpulkan di [`scripts/soal10.sh`](scripts/soal10.sh).

#### 1. Konfigurasi Autostart DHCP Server pada `tengen`
Pada node Tengen, pastikan interface IPv4 diarahkan ke `eth0` dan service didaftarkan ke runlevel default:
```bash
# 1. Konfigurasi interface di /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server

# 2. Daftarkan service ke startup runlevel
update-rc.d isc-dhcp-server defaults

# 3. Validasi sintaks dan restart service
dhcpd -t -4 -cf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
```

#### 2. Konfigurasi Autostart DHCP Relay pada `jichi`
Pada node Jichi (lingkungan Docker/GNS3), service relay bawaan seringkali memerlukan antarmuka yang siap sebelum proses dijalankan. Oleh karena itu, dibuat mekanisme service kustom dengan pemanggilan via `/etc/rc.local`:

1. Buat script launcher `/usr/local/sbin/start-dhcrelay-soal10.sh`:
```bash
cat <<'EOF' > /usr/local/sbin/start-dhcrelay-soal10.sh
#!/bin/sh
pkill -x dhcrelay 2>/dev/null || true
sleep 1
/usr/sbin/dhcrelay -4 -id eth2 -id eth3 -iu eth4 10.82.4.10 >/tmp/dhcrelay.log 2>&1 &
EOF
chmod +x /usr/local/sbin/start-dhcrelay-soal10.sh
```

2. Buat init script `/etc/init.d/dhcrelay-custom`:
```bash
cat <<'EOF' > /etc/init.d/dhcrelay-custom
#!/bin/sh
case "$1" in
    start)
        echo "Menjalankan DHCP Relay..."
        /usr/local/sbin/start-dhcrelay-soal10.sh
        sleep 2
        pgrep -af dhcrelay || true
        ;;
    stop)
        pkill -x dhcrelay 2>/dev/null || true
        echo "DHCP Relay dihentikan."
        ;;
    restart)
        "$0" stop
        sleep 1
        "$0" start
        ;;
    status)
        pgrep -af dhcrelay || true
        ;;
    *)
        echo "Penggunaan: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF
chmod +x /etc/init.d/dhcrelay-custom
update-rc.d dhcrelay-custom defaults 2>/dev/null || true
```

3. Tambahkan pemicu pada `/etc/rc.local`:
```bash
cat <<'EOF' > /etc/rc.local
#!/bin/sh
sleep 3
/etc/init.d/dhcrelay-custom start
exit 0
EOF
chmod +x /etc/rc.local
```

#### 3. Prosedur Pengujian Restart
1. Lakukan restart (*stop & start* / reboot) pada node **tengen** dan **jichi** di GNS3.
2. Setelah kedua node menyala kembali, periksa status service dan proses.
3. Jalankan pengujian request DHCP pada client Network 2 dan Network 3.

---

### Bukti Pengujian & Hasil Verifikasi

1. **Bukti Autostart DHCP Server di Server `tengen`**:
   Pengecekan file `/etc/default/isc-dhcp-server` dan tautan simbolik runlevel di `/etc/rc2.d/` membuktikan `isc-dhcp-server` aktif di runlevel 2 secara otomatis (`S01isc-dhcp-server`):
   ![Autostart DHCP Server di Tengen](assets/10-tengen-autostart.png)

2. **Bukti Autostart DHCP Relay di Router `jichi`**:
   Tampilan isi `/etc/rc.local` dan verifikasi keberadaan proses `dhcrelay` yang aktif berjalan secara otomatis di latar belakang dengan interface `-id eth2 -id eth3 -iu eth4 10.82.4.10`:
   ![Autostart DHCP Relay di Jichi](assets/10-jichi-relay-autostart.png)

3. **Bukti Permintaan Lease Client Pasca-Restart**:
   Pengujian renew lease pada client Network 2 (`zenin` dan `fushiguro`) setelah node router dan server di-restart:
   ![Hasil Uji Lease Client Pasca-Restart](assets/10-client-lease-post-restart.png)

Tabel hasil verifikasi status client pasca-restart:

| Client | Kelompok / Pool | MAC Address | IP Address Diperoleh | Gateway | Status Pasca-Restart |
|---|---|---|---|---|---|
| **fushiguro** | Dev (Pool 1) | `02:42:05:ec:37:00` | `10.82.2.10` | `10.82.2.1` | Berhasil (Sesuai Pool 1) |
| **zenin** | Support (Pool 2) | `02:42:43:4a:ba:00` | `10.82.2.71` | `10.82.2.1` | Berhasil (Sesuai Pool 2) |

---

### Analisis Hasil & Kesimpulan
* Konfigurasi runlevel pada node `tengen` memastikan service `isc-dhcp-server` langsung berjalan segera setelah sistem operasi selesai memuat modul jaringan.
* Penggunaan init script kustom dan pemicu `/etc/rc.local` pada router `jichi` berhasil mengatasi kendala startup relay pada node container, sehingga proses `dhcrelay` otomatis mendengarkan antarmuka `eth2`, `eth3`, dan `eth4`.
* Pengujian pada client membuktikan bahwa pasca-restart seluruh node infrastruktur (router dan server), layanan alokasi IP dinamis tetap beroperasi secara transparan dan seluruh aturan kebijakan (Pool 1, Pool 2, short lease, long lease, serta static lease) tetap terjaga konsistensinya.

---

### Soal No. 10
> Setelah gangguan Shibuya tertangani, pastikan pemulihan bertahan setelah restart. Aktifkan autostart DHCP Server pada tengen dan DHCP Relay pada jichi, lalu restart kedua node. Verifikasi status layanan, IP, gateway, lease, dan konektivitas client Network 2–3. Pastikan kebijakan Pool 1, Pool 2, short lease, long lease, dan fixed address tetap berlaku.