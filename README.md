# FDM Brave Bridge

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-orange.svg)]()
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)]()

A lightweight, automated integration utility that fixes the connection between the **Free Download Manager (FDM)** browser extension and **Brave Browser** across Linux distributions.

---

## 📌 Problem Overview

On Linux, Brave frequently stores user profile configurations inside:
`~/.config/BraveSoftware/Brave-Origin` instead of `Brave-Browser`.

Because FDM's installer only inspects default Google Chrome and Chromium directories, the extension fails with the following message:
> *"Settings aren't available for your FDM version. Please update it."*

This script detects the installed FDM native manifest and symlinks it across all Brave directory structures (Native, Flatpak, and Snap builds).

---

## ⚡ Quick Install (One-Liner)

Run directly in terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/dain09/fdm-brave-bridge/main/install.sh | bash
```

---

## 🛠 Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/dain09/fdm-brave-bridge.git
   cd fdm-brave-bridge
   ```

2. **Make executable and run:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

---

## 🔄 Uninstallation

To remove all created symlinks and configurations:

```bash
./install.sh --uninstall
```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for details.
