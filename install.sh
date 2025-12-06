#!/bin/bash
# ======================================================
#         Pterodactyl Panel Installer Script
# ======================================================
# Author: Fhiya Frinella
# Description: Installer & Uninstaller Protect/Unprotect Panel + Anti Delete Admin
# ======================================================

# ================== COLOR ==================
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ================== UTILITY FUNCTIONS ==================
print_header() {
    local title="$1"
    echo -e "\n${BLUE}[+]===============================================+[+]${NC}"
    echo -e "${BLUE}[+] $title ${BLUE}[+]${NC}"
    echo -e "${BLUE}[+]===============================================+[+]${NC}\n"
}

print_success() {
    echo -e "${GREEN}[+] $1 [+]${NC}"
}

print_error() {
    echo -e "${RED}[!] $1 [!]${NC}"
}

pause() {
    read -rp "Tekan Enter untuk melanjutkan..." dummy
}

# ================== INSTALL DEPENDENCIES ==================
install_dependencies() {
    print_header "UPDATE & INSTALL DEPENDENCIES"
    sudo apt update && sudo apt install -y jq curl unzip
    if [ $? -eq 0 ]; then
        print_success "Dependencies berhasil diinstall!"
    else
        print_error "Install dependencies gagal!"
        exit 1
    fi
    sleep 1
    clear
}

# ================== PANEL PROTECTION ==================
install_protect_panel() {
    print_header "INSTALL PROTECT PANEL"
    local urls=(
        "installprotect1.sh"
        "installprotect2.sh"
        "installprotect3.sh"
        "installprotect4.sh"
        "installprotect5.sh"
        "installprotect6.sh"
        "installprotect7.sh"
        "installprotect8.sh"
        "installprotect9.sh"
        "installprotect10.sh"
        "installprotect11.sh"
    )

    for script in "${urls[@]}"; do
        curl -fsSL "https://raw.githubusercontent.com/yopi-def/ptero-addons/refs/heads/main/$script" | bash
    done

    print_success "Protect Panel berhasil diinstall!"
    pause
}

uninstall_protect_panel() {
    print_header "UNINSTALL PROTECT PANEL"
    local urls=(
        "uninstallprotect1.sh"
        "uninstallprotect2.sh"
        "uninstallprotect3.sh"
        "uninstallprotect4.sh"
        "uninstallprotect5.sh"
        "uninstallprotect6.sh"
        "uninstallprotect7.sh"
        "uninstallprotect8.sh"
        "uninstallprotect9.sh"
        "uninstallprotect10.sh"
        "uninstallprotect11.sh"
    )

    for script in "${urls[@]}"; do
        curl -fsSL "https://raw.githubusercontent.com/yopi-def/ptero-addons/refs/heads/main/$script" | bash
    done

    print_success "Protect Panel berhasil di-uninstall!"
    pause
}

# ================== PROTECT ANTI DELETE ADMIN ==================
protect_admin_delete() {
    print_header "PROTECT ANTI DELETE ADMIN"

    # Pastikan dijalankan sebagai root
    if [ "$EUID" -ne 0 ]; then
        print_error "Harap jalankan skrip ini sebagai root."
        exit 1
    fi

    read -rp "Masukkan User ID yang tidak boleh dihapus (contoh: 1): " PROTECTED_USER_ID

    if [[ ! "$PROTECTED_USER_ID" =~ ^[0-9]+$ ]]; then
        print_error "User ID harus berupa angka. Keluar."
        exit 1
    fi

    CONTROLLER_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"

    if [ -f "$CONTROLLER_PATH" ]; then
        echo "Mengganti fungsi delete di UserController.php..."
        sed -i "/public function delete(Request \$request, User \$user): RedirectResponse {/,/^}/c\\
    public function delete(Request \$request, User \$user): RedirectResponse {\\
        if (\$user->id === $PROTECTED_USER_ID) {\\
            throw new DisplayException('Dilarang Menghapus Admin Panel Utama');\\
        }\\
        if (\$request->user()->id === \$user->id) {\\
            throw new DisplayException('Anda tidak dapat menghapus akun Anda sendiri.');\\
        }\\
        \$this->deletionService->handle(\$user);\\
        return redirect()->route('admin.users');\\
    }" "$CONTROLLER_PATH"

        print_success "Proteksi Anti Delete Admin berhasil diterapkan!"
    else
        print_error "File UserController.php tidak ditemukan di $CONTROLLER_PATH."
        exit 1
    fi
    pause
}

# ================== HACK BACK PANEL ==================
hackback_panel() {
    print_header "HACK BACK PANEL"

    read -rp "Masukkan Username Admin: " username
    read -rp "Masukkan Email Admin: " email
    read -rp "Masukkan Password Admin: " password

    cd /var/www/pterodactyl || { print_error "Direktori /var/www/pterodactyl tidak ditemukan!"; exit 1; }

    php artisan p:user:make <<EOF
yes
$email
$username
$username
$username
$password
EOF

    print_success "Akun Admin berhasil dibuat!"
    pause
}

# ================== MAIN MENU ==================
main_menu() {
    while true; do
        clear
        print_header "PTERODACTYL PANEL MANAGEMENT"
        echo -e "${YELLOW}1.${NC} Install Protect Panel"
        echo -e "${YELLOW}2.${NC} Uninstall Protect Panel"
        echo -e "${YELLOW}3.${NC} Hack Back Panel"
        echo -e "${YELLOW}4.${NC} Proteksi Anti Delete Admin"
        echo -e "${YELLOW}x.${NC} Exit"
        echo -ne "\nMasukkan pilihan: "
        read -r choice

        case "$choice" in
            1) install_protect_panel ;;
            2) uninstall_protect_panel ;;
            3) hackback_panel ;;
            4) protect_admin_delete ;;
            x|X) echo "Keluar dari script."; exit 0 ;;
            *) print_error "Pilihan tidak valid!" ; pause ;;
        esac
    done
}

# ================== SCRIPT START ==================
install_dependencies
main_menu