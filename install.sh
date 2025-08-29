#!/bin/bash

# =============================================================================
# install.sh - Automated Arch Linux Desktop Setup
# =============================================================================
# This script transforms a minimal Arch Linux installation into a complete,
# themed Hyprland desktop environment by installing packages and deploying
# dotfiles.
#
# RUN FROM: ~/dotfiles/
# =============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Logging Functions ---
# Provides colored output for better readability.
log_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

log_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

log_warning() {
    echo -e "\e[33m[WARNING]\e[0m $1"
}

log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

# --- Initial Sanity Checks ---
log_info "Starting automated desktop setup..."

# Check for root privileges for pacman commands
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root. Run as a regular user with sudo privileges."
fi

# Check for internet connection
if ! ping -c 1 archlinux.org &> /dev/null; then
    log_error "No internet connection. Please connect to the internet and try again."
fi

# --- SYSTEM UPDATE & PREREQUISITES ---
log_info "Synchronizing package databases and updating system..."
sudo pacman -Syu --noconfirm

log_info "Installing prerequisites for building AUR packages (base-devel)..."
sudo pacman -S --needed base-devel --noconfirm

# --- AUR HELPER (yay) ---
if ! command -v yay &> /dev/null; then
    log_info "AUR helper 'yay' not found. Installing..."
    cd /opt
    sudo git clone https://aur.archlinux.org/yay.git
    sudo chown -R "$USER":"$USER" ./yay
    cd yay
    makepkg -si --noconfirm
    cd "$HOME"/dotfiles
    log_success "'yay' has been installed."
else
    log_info "'yay' is already installed."
fi

# --- PACKAGE INSTALLATION ---
log_info "Installing packages from official repositories (pkglist.txt)..."
if [ -f "pkglist.txt" ]; then
    sudo pacman -S --needed - < pkglist.txt
    log_success "Official packages installed."
else
    log_warning "pkglist.txt not found. Skipping pacman installations."
fi

log_info "Installing packages from the AUR (aur-pkglist.txt)..."
if [ -f "aur-pkglist.txt" ]; then
    yay -S --needed - < aur-pkglist.txt
    log_success "AUR packages installed."
else
    log_warning "aur-pkglist.txt not found. Skipping AUR installations."
fi

# --- DEPLOY DOTFILES WITH STOW ---
log_info "Deploying dotfiles using GNU Stow..."
# This assumes you have folders in your repo like 'hypr', 'foot', 'eww', etc.
# Add every folder you want to link to this line.
stow hypr foot eww # Add other directories here as you create them

log_success "Dotfiles have been deployed."

# --- ENABLE SYSTEM SERVICES ---
log_info "Enabling essential system services..."
sudo systemctl enable greetd.service
sudo systemctl enable NetworkManager.service # Should be on, but good to be sure.

log_success "System services enabled."

# --- FINAL INSTRUCTIONS ---
echo
log_success "Automated setup is complete!"
echo
log_warning "CRITICAL POST-INSTALLATION STEP:"
log_warning "You MUST now configure greetd to start your session."
log_warning "Edit '/etc/greetd/config.toml' and set the command."
log_warning "Example: command = \"regreet --cmd Hyprland\""
echo
log_info "After configuring greetd, please reboot your system."
echo