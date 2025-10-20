#!/usr/bin/env bash
# ============================================
# Bootstrap Script for Dotfiles
# ============================================
# Cross-platform dotfiles installer (macOS & Arch Linux)
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/arch-release ]; then
            OS="arch"
        else
            OS="linux"
        fi
    else
        error "Unsupported OS: $OSTYPE"
    fi
    info "Detected OS: $OS"
}

# Install prerequisites
install_prerequisites() {
    info "Installing prerequisites..."

    if [ "$OS" = "macos" ]; then
        # Check if Xcode Command Line Tools are installed
        if ! xcode-select -p &>/dev/null; then
            info "Installing Xcode Command Line Tools..."
            xcode-select --install
            warning "Please complete the Xcode installation and re-run this script"
            exit 0
        fi

        # Install Homebrew
        if ! command -v brew &>/dev/null; then
            info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for Apple Silicon
            if [[ $(uname -m) == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        else
            success "Homebrew already installed"
        fi

    elif [ "$OS" = "arch" ]; then
        # Update system
        info "Updating system packages..."
        sudo pacman -Syu --noconfirm

        # Install needed packages for setup 
        info "Ensuring git, curl and base-devel are installed..."
        sudo pacman -S --needed --noconfirm git curl base-devel

        # Install paru if not present
       if ! command -v paru &>/dev/null; then
            echo "Installing paru (AUR helper)..."

            # Clone and build paru
            TEMP_DIR=$(mktemp -d)

            if git clone https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"; then
                cd "$TEMP_DIR/paru"

                if makepkg -si --noconfirm; then
                    echo "✓ paru installed successfully"
                else
                    echo "⚠ Failed to build paru, skipping"
                    cd "$HOME"
                    rm -rf "$TEMP_DIR"
                    exit 0
                fi

                # Clean up
                cd "$HOME"
                rm -rf "$TEMP_DIR"
            else
                echo "⚠ Failed to clone paru repository, skipping"
                rm -rf "$TEMP_DIR"
                exit 0
            fi
        else
            echo "✓ paru already installed"
        fi
    fi

    success "Prerequisites installed"
}

# Install chezmoi
install_chezmoi() {
    if command -v chezmoi &>/dev/null; then
        success "chezmoi already installed"
        return
    fi

    info "Installing chezmoi..."

    if [ "$OS" = "macos" ]; then
        brew install chezmoi
    elif [ "$OS" = "arch" ]; then
        sudo pacman -S --needed --noconfirm chezmoi
    fi

    success "chezmoi installed"
}

# Initialize dotfiles
init_dotfiles() {
    info "Initializing dotfiles with chezmoi..."

    # Initialize chezmoi with the repo
    info "Cloning dotfiles from github.com/fcalell/dotfiles..."
    chezmoi init fcalell

    success "Dotfiles initialized"
}

init_shell() {
    echo "Setting up shell..."

    # Set zsh as default shell if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        echo "✓ Default shell set to zsh"
    else
        echo "✓ zsh is already the default shell"
    fi

    # Install Zinit if not present
    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    if [ ! -d "$ZINIT_HOME" ]; then
        echo "Installing Zinit..."
        mkdir -p "$(dirname "$ZINIT_HOME")"
        if git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
            echo "✓ Zinit installed"
        else
            echo "⚠ Failed to install Zinit"
            exit 1
        fi
    else
        echo "✓ Zinit already installed"
    fi

    echo "✓ Shell setup complete"
}

# Main installation flow
main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║                                                       ║"
    echo "║        Dotfiles Bootstrap Script by fcalell           ║"
    echo "║        Cross-platform setup (macOS & Arch)            ║"
    echo "║                                                       ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo ""

    detect_os
    install_prerequisites
    install_chezmoi
    init_dotfiles
    init_shell

    echo ""
    success "Bootstrap complete!"
    echo ""
    info "Next steps:"
    echo "  1. Restart your shell or run: exec \$SHELL"
    if [ "$OS" = "macos" ]; then
        echo "  2. Packages will be installed automatically via Brewfile"
    elif [ "$OS" = "arch" ]; then
        echo "  2. Packages will be installed automatically via pacman/paru"
    fi
    echo "  3. Review ~/.config for all configurations"
    echo ""
}

# Run main
main
