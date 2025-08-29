# Kimochiii Dotfiles

This repository contains the configuration files for my minimalist, aesthetics-focused, and highly-performant Arch Linux desktop environment, built around the Hyprland compositor.

The entire system is managed as code and is designed to be deployed on a minimal Arch Linux installation with a single script.

![scrot](https://link-to-your-screenshot.png) <!-- It's highly recommended to take a screenshot and upload it somewhere -->

---

## Core Philosophy

*   **Aesthetics as a Priority:** The desktop should not only be functional but also beautiful and visually cohesive. All components are themed from a single, dynamic source of truth.
*   **Performance is Key:** Every component is chosen for its speed and low resource usage, creating a frictionless and responsive experience.
*   **Developer-Centric Workflow:** The UI and its configuration are designed for a developer, leveraging scripting, CSS-based styling, and a powerful, minimalist terminal.
*   **Total Ownership:** By building a custom UI and theme from the ground up, the environment is a unique and personal expression, not a preset.

## The Stack

This setup is a carefully curated selection of best-in-class, Wayland-native applications and tools.

| Category | Component | Description |
| :--- | :--- | :--- |
| **Compositor** | [Hyprland](https://hyprland.org/) | The core of the system. A dynamic tiling Wayland compositor. |
| **UI System** | [Eww](https://github.com/elkowar/eww) | A widget toolkit used to build the bar, dock, and other UI elements. |
| **Terminal** | [Foot](https://codeberg.org/dnkl/foot) | A fast, minimalist, and Wayland-native terminal emulator. |
| **Login Manager** | [Greetd](https://git.sr.ht/~kennylevinsen/greetd) + [Regreet](https://github.com/payne-d/regreet) | A minimal display manager with a themable, GTK 4 greeter. |
| **Theming Engine**| [Wallust](https://github.com/dylanaraps/wallust) | A Rust-based tool for generating color palettes from wallpapers. |
| **Screen Locker** | [hyprlock](https://github.com/hyprwm/hyprlock) | The native, themable screen locker for Hyprland. |
| **File Manager** | [Thunar](https://docs.xfce.org/xfce/thunar/start) | A lightweight and performant GTK-based file manager. |
| **Audio System** | [PipeWire](https://pipewire.org/) | The modern audio and video server for Linux. |
| **Font** | [JetBrains Mono Nerd Font](https://www.nerdfonts.com/) | The primary font, providing essential icons for the UI. |

---

## Installation

This setup is designed to be deployed on a fresh, minimal Arch Linux installation. The process is divided into two phases: a manual bootstrap and an automated build-out.

### Phase 1: Manual Bootstrap

1.  Follow the official [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide) to install a minimal base system.
2.  During the `pacstrap` step, install only the absolute essentials:
    ```bash
    pacstrap -K /mnt base linux linux-firmware networkmanager nano git sudo
    ```
3.  Complete the installation, including creating a user with `sudo` privileges and installing a bootloader.
4.  Reboot into the new system and log in at the TTY.

### Phase 2: Automated Build-out

1.  Connect to the internet.
2.  Clone this repository:
    ```bash
    git clone https://your-repo-url/dotfiles.git
    ```
3.  Run the installation script:
    ```bash
    cd dotfiles
    ./install.sh
    ```
4.  **Critical Post-Install Step:** Configure `greetd` to start the Hyprland session. Edit `/etc/greetd/config.toml` as root and ensure the command is set correctly:
    ```toml
    # /etc/greetd/config.toml
    [default_session]
    command = "regreet"
    ```
5.  Reboot the system:
    ```bash
    sudo reboot
    ```

The system will now boot into a fully configured and themed desktop environment.