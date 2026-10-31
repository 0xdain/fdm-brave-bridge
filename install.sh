#!/usr/bin/env bash

# ==============================================================================
# FDM Brave Bridge - Native Messaging Host Linker
# Automates integration between Free Download Manager and Brave Browser on Linux
# ==============================================================================

set -eo pipefail

GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TARGET_DIRS=(
    "$HOME/.config/BraveSoftware/Brave-Origin/NativeMessagingHosts"
    "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
    "$HOME/.config/BraveSoftware/Brave-Browser-Beta/NativeMessagingHosts"
    "$HOME/.config/BraveSoftware/Brave-Browser-Nightly/NativeMessagingHosts"
    "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Origin/NativeMessagingHosts"
    "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
    "$HOME/snap/brave/current/.config/BraveSoftware/Brave-Origin/NativeMessagingHosts"
    "$HOME/snap/brave/current/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
)

uninstall() {
    log_info "Removing FDM integration links from Brave..."
    local count=0
    for dir in "${TARGET_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            for manifest in "$dir"/*fdm*.json; do
                if [ -e "$manifest" ] || [ -L "$manifest" ]; then
                    rm -f "$manifest"
                    count=$((count + 1))
                fi
            done
        fi
    done
    log_ok "Removed $count integration files/links. Integration uninstalled."
    exit 0
}

if [[ "$1" == "--uninstall" || "$1" == "-u" ]]; then
    uninstall
fi

echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}      FDM Brave Integration Installer        ${NC}"
echo -e "${BLUE}==============================================${NC}"

log_info "Searching for Free Download Manager native messaging manifest..."

FDM_MANIFEST=$(find /opt/freedownloadmanager /etc ~/.config -name "*fdm*.json" 2>/dev/null | head -n 1 || true)

if [ -z "$FDM_MANIFEST" ]; then
    log_error "FDM native messaging host manifest could not be found."
    echo "Please ensure Free Download Manager is installed correctly before running this script."
    exit 1
fi

log_ok "Detected manifest: $FDM_MANIFEST"

LINKED_COUNT=0

for dir in "${TARGET_DIRS[@]}"; do
    parent_dir=$(dirname "$dir")
    if [ -d "$parent_dir" ]; then
        mkdir -p "$dir"
        ln -sf "$FDM_MANIFEST" "$dir/"
        log_ok "Linked -> $dir"
        LINKED_COUNT=$((LINKED_COUNT + 1))
    fi
done

if [ $LINKED_COUNT -eq 0 ]; then
    DEFAULT_DIR="$HOME/.config/BraveSoftware/Brave-Origin/NativeMessagingHosts"
    mkdir -p "$DEFAULT_DIR"
    ln -sf "$FDM_MANIFEST" "$DEFAULT_DIR/"
    log_ok "Created default directory and linked -> $DEFAULT_DIR"
    LINKED_COUNT=1
fi

echo -e "\n${GREEN}✔ Installation completed successfully! (${LINKED_COUNT} profile paths updated)${NC}"
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Close and fully restart Brave Browser."
echo "  2. Ensure Free Download Manager is launched."
echo "  3. Click the FDM extension icon in Brave toolbar to verify."
