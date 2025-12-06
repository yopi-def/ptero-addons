# 🐦 Pterodactyl Panel & MySQL Installer Guide

Selamat datang di panduan **instalasi dan konfigurasi Pterodactyl Panel** beserta MySQL/phpMyAdmin.  
Panduan ini cocok untuk **server Ubuntu/Debian** dan lengkap dengan cara install panel, install MySQL, setup domain, dan proteksi database.

---

## 🔹 1. Install Pterodactyl Panel Otomatis

Gunakan skrip installer resmi dari Pterodactyl:

bash <(curl -s https://pterodactyl-installer.se)

Skrip ini akan otomatis mengatur:
- Node.js
- Panel dependencies
- Webserver configuration
- Database configuration

> **Tips:** Pastikan server dijalankan sebagai **root** agar tidak ada kendala permission.

---

## 🔹 2. Installer All-in-One (Panel, MySQL, Domain, dll)

Untuk setup tambahan atau switch domain, gunakan skrip ini:

bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)

Fitur yang tersedia:
- Install Pterodactyl Panel
- Install MySQL & phpMyAdmin
- Switch domain / SSL
- Backup dan restore database
- Update panel & dependencies

---

## 🔹 3. Install MySQL & phpMyAdmin Manual

Jika ingin menginstall MySQL secara manual:

sudo apt update
sudo apt install phpmyadmin

Setelah selesai, kita perlu menambahkan konfigurasi phpMyAdmin ke Nginx.

### Edit konfigurasi Nginx:

sudo nano /etc/nginx/sites-available/pterodactyl.conf

Tambahkan bagian ini **di dalam server block**:

# phpMyAdmin
location /phpmyadmin {
    root /usr/share/;
    index index.php index.html index.htm;
    
    location ~ ^/phpmyadmin/(.+\.php)$ {
        try_files $uri =404;
        root /usr/share/;
        fastcgi_pass unix:/var/run/php/php8.5-fpm.sock; # sesuaikan versi PHP
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        root /usr/share/;
    }
}

> ⚠️ Jangan lupa restart Nginx setelah perubahan:

sudo systemctl restart nginx

---

## 🔹 4. Cek Versi PHP Aktif

Sebelum mengedit fastcgi_pass, pastikan versi PHP yang aktif:

sudo systemctl list-units | grep php

Contoh output:

php8.1-fpm.service   loaded active running PHP 8.1 FPM
php8.2-fpm.service   loaded inactive dead

> Gunakan versi PHP **yang aktif** pada fastcgi_pass:  
> Misal: fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;

Atau cek via command line:

php -v

Output akan menampilkan versi PHP CLI:

PHP 8.1.18 (cli) (built: ...)

---

## 🔹 5. Tips & Best Practices

- **Selalu backup** file konfigurasi sebelum diubah.
- Gunakan **root atau sudo** untuk installasi dan edit file sistem.
- Untuk panel proteksi, pastikan admin utama (ID 1) memiliki akses penuh.
- Setelah konfigurasi Nginx atau PHP-FPM diubah, jalankan:

sudo systemctl restart nginx
sudo systemctl restart php8.x-fpm

- Gunakan **skrip installer** untuk setup otomatis agar lebih aman dan cepat.

---

## 🔹 6. Link Installer

| Fitur                  | Perintah                                                                 |
|------------------------|--------------------------------------------------------------------------|
| Install Panel          | bash <(curl -s https://pterodactyl-installer.se)                        |
| All-in-One Installer   | bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh) |
| Install MySQL Manual   | sudo apt update && sudo apt install phpmyadmin                           |

---

## 🔹 7. Support / Troubleshooting

Jika ada error:
- Pastikan **server dijalankan sebagai root**.
- Cek **PHP version dan service status**.
- Pastikan **Nginx & PHP-FPM restart** setelah konfigurasi.

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
