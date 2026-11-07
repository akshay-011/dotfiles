#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Setup & Installer Script
# ==============================================================================
# Idempotent: safe to run multiple times on fresh OS or existing installs.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".bak.$(date +%s)"

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_GREEN='\033[32m'
C_BLUE='\033[34m'
C_YELLOW='\033[33m'
C_RED='\033[31m'

info()  { printf "${C_BLUE}${C_BOLD}[INFO]${C_RESET} %s\n" "$*"; }
ok()    { printf "${C_GREEN}${C_BOLD}[OK]${C_RESET}   %s\n" "$*"; }
warn()  { printf "${C_YELLOW}${C_BOLD}[WARN]${C_RESET} %s\n" "$*"; }
error() { printf "${C_RED}${C_BOLD}[ERR]${C_RESET}  %s\n" "$*" >&2; }

printf "\n${C_BOLD}=== Installing Akshay's Modern Terminal Dotfiles ===${C_RESET}\n\n"
info "Source directory: $DOTFILES_DIR"

# ------------------------------------------------------------------------------
# 1. Package Installation
# ------------------------------------------------------------------------------
install_packages() {
  info "Checking system package manager..."

  if command -v pacman &>/dev/null; then
    info "Detected Arch Linux / Omarchy (pacman). Installing packages..."
    sudo pacman -S --needed --noconfirm \
      git curl foot starship bat eza fzf fd zoxide neovim ttf-jetbrains-mono-nerd 2>/dev/null || \
      warn "Some pacman packages may require manual install or AUR."

  elif command -v apt-get &>/dev/null; then
    info "Detected Debian / Ubuntu (apt). Installing packages..."
    sudo apt-get update -y
    sudo apt-get install -y git curl foot fzf fd-find zoxide neovim bat 2>/dev/null || true
    # Symlink fcat / fdfind if debian names them differently
    mkdir -p "$HOME/.local/bin"
    command -v fdfind &>/dev/null && ln -sf "$(which fdfind)" "$HOME/.local/bin/fd" || true
    command -v batcat &>/dev/null && ln -sf "$(which batcat)" "$HOME/.local/bin/bat" || true

  elif command -v dnf &>/dev/null; then
    info "Detected Fedora (dnf). Installing packages..."
    sudo dnf install -y git curl foot starship bat eza fzf fd-find zoxide neovim jetbrains-mono-fonts || true

  elif command -v brew &>/dev/null; then
    info "Detected Homebrew. Installing packages..."
    brew install starship bat eza fzf fd zoxide neovim || true
  else
    warn "Unrecognized package manager. Please ensure starship, bat, eza, fzf, fd, and zoxide are installed."
  fi
}

# ------------------------------------------------------------------------------
# 2. Standalone Tools (Starship, Yazi, Glow, ble.sh)
# ------------------------------------------------------------------------------
install_standalone_tools() {
  mkdir -p "$HOME/.local/bin"

  # Starship (fallback installer if not in repo)
  if ! command -v starship &>/dev/null; then
    info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
  fi

  # Yazi File Manager
  if ! command -v yazi &>/dev/null; then
    info "Installing Yazi terminal file manager..."
    local yazi_ver="v25.5.31"
    local yazi_tar="/tmp/yazi.zip"
    curl -fsSL "https://github.com/sxyazi/yazi/releases/download/${yazi_ver}/yazi-x86_64-unknown-linux-musl.zip" -o "$yazi_tar" 2>/dev/null && {
      unzip -q -o "$yazi_tar" -d /tmp/
      install -m 755 "/tmp/yazi-x86_64-unknown-linux-musl/yazi" "$HOME/.local/bin/yazi"
      rm -rf "$yazi_tar" "/tmp/yazi-x86_64-unknown-linux-musl"
      ok "Yazi installed to ~/.local/bin/yazi"
    } || warn "Could not auto-download Yazi. Install via your package manager."
  fi

  # Glow Markdown Pager
  if ! command -v glow &>/dev/null; then
    info "Installing Glow markdown viewer..."
    local glow_ver="2.1.1"
    local glow_tar="/tmp/glow.tar.gz"
    curl -fsSL "https://github.com/charmbracelet/glow/releases/download/v${glow_ver}/glow_${glow_ver}_linux_x86_64.tar.gz" -o "$glow_tar" 2>/dev/null && {
      tar -xzf "$glow_tar" -C /tmp/
      install -m 755 "/tmp/glow_${glow_ver}_linux_x86_64/glow" "$HOME/.local/bin/glow"
      rm -rf "$glow_tar" "/tmp/glow_${glow_ver}_linux_x86_64"
      ok "Glow installed to ~/.local/bin/glow"
    } || warn "Could not auto-download Glow. Install via your package manager."
  fi

  # ble.sh (Bash Line Editor)
  if [[ ! -d "$HOME/.local/share/blesh" ]]; then
    info "Installing ble.sh (syntax highlighting & autosuggestions)..."
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "/tmp/blesh" 2>/dev/null && {
      make -C "/tmp/blesh" install PREFIX="$HOME/.local"
      rm -rf "/tmp/blesh"
      ok "ble.sh installed to ~/.local/share/blesh"
    } || warn "Could not build ble.sh. Please install git and make."
  fi
}

# ------------------------------------------------------------------------------
# 3. Create Symlinks
# ------------------------------------------------------------------------------
link_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  # If destination is already the correct symlink, skip
  if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
    ok "Already linked: $dest"
    return 0
  fi

  # Backup existing file if present
  if [[ -e "$dest" || -L "$dest" ]]; then
    warn "Backing up existing $dest -> ${dest}${BACKUP_SUFFIX}"
    mv "$dest" "${dest}${BACKUP_SUFFIX}"
  fi

  ln -sfn "$src" "$dest"
  ok "Linked: $dest -> $src"
}

apply_symlinks() {
  info "Linking configuration files..."
  link_file "$DOTFILES_DIR/.config/foot/foot.ini" "$HOME/.config/foot/foot.ini"
  link_file "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
  link_file "$DOTFILES_DIR/.config/terminal-cheatsheet.md" "$HOME/.config/terminal-cheatsheet.md"
  link_file "$DOTFILES_DIR/.config/nvim/plugin/after/transparency.lua" "$HOME/.config/nvim/plugin/after/transparency.lua"
  link_file "$DOTFILES_DIR/.blerc" "$HOME/.blerc"
  link_file "$DOTFILES_DIR/.bash_custom" "$HOME/.bash_custom"
}

# ------------------------------------------------------------------------------
# 4. Integrate with ~/.bashrc
# ------------------------------------------------------------------------------
update_bashrc() {
  info "Checking ~/.bashrc integration..."
  local bashrc="$HOME/.bashrc"
  touch "$bashrc"

  # Ensure ble.sh is sourced early if interactive
  if ! grep -q "blesh/ble.sh" "$bashrc"; then
    info "Adding ble.sh loader to ~/.bashrc..."
    local blesh_block='
# Bash Line Editor (ble.sh)
[[ $- == *i* && -r ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach
'
    printf "%s\n" "$blesh_block" | cat - "$bashrc" > "${bashrc}.tmp" && mv "${bashrc}.tmp" "$bashrc"
  fi

  # Ensure ~/.bash_custom is sourced
  if ! grep -q "source ~/.bash_custom" "$bashrc" && ! grep -q "\. ~/.bash_custom" "$bashrc"; then
    info "Hooking ~/.bash_custom into ~/.bashrc..."
    cat >> "$bashrc" << 'EOF'

# Load Custom Dotfiles Configuration
[[ -f ~/.bash_custom ]] && source ~/.bash_custom

# Attach ble.sh (must be last in bashrc)
[[ ${BLE_VERSION-} ]] && ble-attach
EOF
    ok "Hooked ~/.bash_custom into ~/.bashrc"
  else
    ok "~/.bash_custom is already sourced in ~/.bashrc"
  fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
  if [[ "${1:-}" != "--skip-packages" ]]; then
    install_packages || true
    install_standalone_tools || true
  fi

  apply_symlinks
  update_bashrc

  printf "\n${C_GREEN}${C_BOLD}✓ Dotfiles setup completed successfully!${C_RESET}\n"
  printf "Restart your terminal or run: ${C_BOLD}source ~/.bashrc${C_RESET}\n"
  printf "Type ${C_BOLD}cheatsheet${C_RESET} to view your shortcut cheatsheet.\n\n"
}

main "$@"
