# 🐦 Pterodactyl Panel & MySQL Installer Guide

Selamat datang di panduan **instalasi dan konfigurasi Pterodactyl Panel** beserta MySQL/phpMyAdmin.  
Panduan ini cocok untuk **server Ubuntu/Debian** dan lengkap dengan cara install panel, install MySQL, setup domain, serta proteksi database.

---

## 🔹 1. Install Pterodactyl Panel Otomatis

Gunakan skrip installer resmi dari Pterodactyl:

```bash
bash <(curl -s https://pterodactyl-installer.se)
```

Skrip ini akan otomatis mengatur:

- Node.js
- Panel dependencies
- Webserver configuration
- Database configuration

> **Tips:** Jalankan sebagai **root** agar tidak ada kendala permission.

---

## 🔹 2. Installer All-in-One (Panel, MySQL, Domain, dll)

Untuk setup tambahan, switch domain, atau update panel:

```bash
bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)
```

Fitur yang tersedia:

- Install Pterodactyl Panel
- Install MySQL & phpMyAdmin
- Switch domain / SSL
- Backup & restore database
- Update panel & dependencies

---

## 🔹 3. Install MySQL & phpMyAdmin Manual

Jika ingin install MySQL secara manual:

```bash
sudo apt update
```

```bash
sudo apt install phpmyadmin
```

### Konfigurasi phpMyAdmin di Nginx

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
        fastcgi_pass unix:/var/run/php/php8.5-fpm.sock; # sesuaikan versi PHP aktif
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

## 🔹 4. Cek Versi PHP Aktif

Sebelum edit `fastcgi_pass`, pastikan PHP-FPM yang aktif:

```bash
sudo systemctl list-units | grep php
```

Contoh output:

```
php8.1-fpm.service   loaded active running PHP 8.1 FPM
php8.2-fpm.service   loaded inactive dead
```

Gunakan versi **active** pada fastcgi_pass:  

```nginx
fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
```

Atau cek via CLI:

```bash
php -v
```
---

## 🔹 5. Ubah user menjadi localhost

masuk ke mysql
```php
mysql
```

user yang diubah itu user yang waktu pertama kali buat panel di ssh

cek user gunakan ini
```php
SELECT user, host FROM mysql.user;
```

```php
RENAME USER '<nama_user>'@'<host_lama>' TO '<nama_user>'@'localhost';
```

```php
FLUSH PRIVILEGES;
```

---

## 🔹 6. Proteksi Admin Panel & Database

Pastikan admin utama memiliki **ID 1** agar tetap bisa akses Nodes & Database.  
Tambahkan snippet proteksi berikut di **NodeController** atau **DatabaseController**:

```php
use Illuminate\Support\Facades\Auth;

$user = Auth::user();
if (!$user || $user->id !== 1) {
    abort(403, '🚫 Akses ditolak! Hanya Admin ID 1.');
}
```

> Letakkan di method: `index`, `create`, `update`, `delete`.

---

## 🔹 6. Tips & Best Practices

- **Backup** semua file konfigurasi sebelum diubah.
- Gunakan **root atau sudo** saat installasi atau edit file sistem.
- Setelah edit Nginx / PHP-FPM:

```bash
sudo systemctl restart nginx
```

```bash
sudo systemctl restart php8.x-fpm
```

- Gunakan skrip installer untuk setup otomatis agar lebih aman & cepat.
- Pastikan **MySQL & phpMyAdmin** terhubung dengan benar ke panel.

---

## 🔹 7. Link Installer

| Fitur                  | Perintah                                                                 |
|------------------------|--------------------------------------------------------------------------|
| Install Panel          | `bash <(curl -s https://pterodactyl-installer.se)`                        |
| All-in-One Installer   | `bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)` |
| Install MySQL Manual   | `sudo apt update && sudo apt install phpmyadmin`                           |

---

## 🔹 8. Support / Troubleshooting

Jika ada error:

- Pastikan **server dijalankan sebagai root**
- Cek **PHP version & service status**
- Pastikan **Nginx & PHP-FPM restart** setelah konfigurasi
- Untuk database/proteksi panel, pastikan admin **ID 1** tetap ada

---

### 💖 Terima kasih telah menggunakan panduan ini!



# Pterodactyl Panel Management Script

**Author:** Fhiya Frinella  
**Description:** Installer & Uninstaller Protect/Unprotect Panel + Anti Delete Admin + Hack Back Admin  
**Platform:** Ubuntu / Debian  
**Requirements:** Root access  

---

## Fitur Utama

1. **Install Protect Panel**  
   - Memasang proteksi untuk mencegah modifikasi dan penghapusan server atau database panel Pterodactyl.

2. **Uninstall Protect Panel**  
   - Menghapus proteksi yang telah dipasang sebelumnya.

3. **Hack Back Panel**  
   - Membuat akun admin baru melalui CLI Laravel Artisan.

4. **Proteksi Anti Delete Admin**  
   - Mencegah penghapusan akun admin utama berdasarkan User ID.

---

## Cara Menggunakan

### Jalankan Script Langsung via CURL

```bash
bash <(curl -s https://h7.cl/1kDAV)
