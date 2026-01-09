# 🐦 Pterodactyl Panel & MySQL Installer Guide

Selamat datang di panduan **instalasi dan konfigurasi Pterodactyl Panel** beserta MySQL/phpMyAdmin.  
Panduan ini cocok untuk **server Ubuntu/Debian** dan lengkap dengan cara install panel, install MySQL, setup domain, serta proteksi database.

---

## 📋 Daftar Isi

1. [Install Pterodactyl Panel Otomatis](#1-install-pterodactyl-panel-otomatis)
2. [Installer All-in-One](#2-installer-all-in-one)
3. [Install MySQL & phpMyAdmin Manual](#3-install-mysql--phpmyadmin-manual)
4. [Cek Versi PHP Aktif](#4-cek-versi-php-aktif)
5. [Ubah User MySQL ke Localhost](#5-ubah-user-mysql-ke-localhost)
6. [Proteksi Admin Panel & Database](#6-proteksi-admin-panel--database)
7. [Management Script](#7-pterodactyl-panel-management-script)
8. [Tips & Best Practices](#8-tips--best-practices)
9. [Support & Troubleshooting](#9-support--troubleshooting)

---

## 1. Install Pterodactyl Panel Otomatis

Gunakan skrip installer resmi dari Pterodactyl:

```bash
bash <(curl -s https://pterodactyl-installer.se)
```

Skrip ini akan otomatis mengatur:
- Node.js
- Panel dependencies
- Webserver configuration
- Database configuration

> **⚠️ Tips:** Jalankan sebagai **root** agar tidak ada kendala permission.

---

## 2. Installer All-in-One

Untuk setup tambahan, switch domain, atau update panel:

```bash
bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)
```

**Fitur yang tersedia:**
- Install Pterodactyl Panel
- Install MySQL & phpMyAdmin
- Switch domain / SSL
- Backup & restore database
- Update panel & dependencies

---

## 3. Install MySQL & phpMyAdmin Manual

### Instalasi Paket

```bash
sudo apt update
sudo apt install phpmyadmin
```

### Konfigurasi phpMyAdmin di Nginx

#### Cara Cepat (Symbolic Link)

```bash
sudo ln -s /usr/share/phpmyadmin /var/www/pterodactyl/public
```

#### Cara Manual (Edit Konfigurasi)

Edit file Nginx untuk Pterodactyl:

```bash
sudo nano /etc/nginx/sites-available/pterodactyl.conf
```

Tambahkan **di dalam server block**:

```nginx
# phpMyAdmin
location /phpmyadmin {
    root /usr/share/;
    index index.php index.html index.htm;
    
    location ~ ^/phpmyadmin/(.+\.php)$ {
        try_files $uri =404;
        root /usr/share/;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock; # sesuaikan versi PHP aktif
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        root /usr/share/;
    }
}
```

Restart Nginx setelah perubahan:

```bash
sudo systemctl restart nginx
```

---

## 4. Cek Versi PHP Aktif

Sebelum edit `fastcgi_pass`, pastikan PHP-FPM yang aktif:

```bash
sudo systemctl list-units | grep php
```

**Contoh output:**

```
php8.1-fpm.service   loaded active running PHP 8.1 FPM
php8.2-fpm.service   loaded inactive dead
```

Gunakan versi **active** pada fastcgi_pass:

```nginx
fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
```

**Alternatif pengecekan via CLI:**

```bash
php -v
```

---

## 5. Ubah User MySQL ke Localhost

### Masuk ke MySQL

```bash
mysql
```

### Cek User yang Ada

```sql
SELECT user, host FROM mysql.user;
```

### Ubah Host User

```sql
RENAME USER '<nama_user>'@'<host_lama>' TO '<nama_user>'@'localhost';
FLUSH PRIVILEGES;
```

### Buat User Baru (Jika Diperlukan)

```sql
-- Buat user baru
CREATE USER 'yopi'@'localhost' IDENTIFIED BY 'password';

-- Berikan hak istimewa global
GRANT ALL PRIVILEGES ON *.* TO 'yopi'@'localhost' WITH GRANT OPTION;

-- Muat ulang hak istimewa
FLUSH PRIVILEGES;
```

---

## 6. Proteksi Admin Panel & Database

Pastikan admin utama memiliki **ID 1** agar tetap bisa akses Nodes & Database.

Tambahkan snippet proteksi berikut di **NodeController** atau **DatabaseController**:

```php
use Illuminate\Support\Facades\Auth;

$user = Auth::user();
if (!$user || $user->id !== 1) {
    abort(403, '🚫 Akses ditolak! Hanya Admin ID 1.');
}
```

> **📍 Lokasi:** Letakkan di method `index`, `create`, `update`, `delete`.

---

## 7. Pterodactyl Panel Management Script

**Author:** Fhiya Frinella  
**Platform:** Ubuntu / Debian  
**Requirements:** Root access

### Fitur Utama

1. **Install Protect Panel** - Proteksi untuk mencegah modifikasi dan penghapusan server atau database
2. **Uninstall Protect Panel** - Menghapus proteksi yang telah dipasang
3. **Hack Back Panel** - Membuat akun admin baru melalui CLI Laravel Artisan
4. **Proteksi Anti Delete Admin** - Mencegah penghapusan akun admin utama berdasarkan User ID

### Cara Menggunakan

```bash
bash <(curl -s https://raw.githubusercontent.com/yopi-def/ptero-addons/refs/heads/main/install.sh)
```

---

## 8. Tips & Best Practices

- ✅ **Backup** semua file konfigurasi sebelum diubah
- ✅ Gunakan **root atau sudo** saat instalasi atau edit file sistem
- ✅ Restart service setelah perubahan konfigurasi:

```bash
sudo systemctl restart nginx
sudo systemctl restart php8.x-fpm
```

- ✅ Gunakan skrip installer untuk setup otomatis agar lebih aman & cepat
- ✅ Pastikan **MySQL & phpMyAdmin** terhubung dengan benar ke panel
- ✅ Pastikan admin **ID 1** tetap ada untuk proteksi panel

---

## 9. Support & Troubleshooting

Jika mengalami error, periksa hal berikut:

- ✔️ Pastikan **server dijalankan sebagai root**
- ✔️ Cek **PHP version & service status**
- ✔️ Pastikan **Nginx & PHP-FPM restart** setelah konfigurasi
- ✔️ Untuk database/proteksi panel, pastikan admin **ID 1** tetap ada

---

## 📚 Link Installer

| Fitur | Perintah |
|-------|----------|
| Install Panel | `bash <(curl -s https://pterodactyl-installer.se)` |
| All-in-One Installer | `bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)` |
| Install MySQL Manual | `sudo apt update && sudo apt install phpmyadmin` |
| Management Script | `bash <(curl -s https://raw.githubusercontent.com/yopi-def/ptero-addons/refs/heads/main/install.sh)` |

---

## 💖 Terima Kasih

Terima kasih telah menggunakan panduan ini! Jika ada pertanyaan atau masukan, silakan buka issue di repository.
