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

        # Install base-devel if not present
        if ! pacman -Qg base-devel &>/dev/null; then
            info "Installing base-devel..."
            sudo pacman -S --needed --noconfirm base-devel
        fi

        # Install git and curl if not present
        info "Ensuring git and curl are installed..."
        sudo pacman -S --needed --noconfirm git curl
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

    # Prompt for GitHub username if not set
    read -p "Enter your GitHub username for dotfiles repo: " GITHUB_USER

    if [ -z "$GITHUB_USER" ]; then
        error "GitHub username is required"
    fi

    # Initialize chezmoi with the repo
    info "Cloning dotfiles from github.com/$GITHUB_USER/dotfiles..."
    chezmoi init --apply "$GITHUB_USER"

    success "Dotfiles initialized"
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

    echo ""
    success "Bootstrap complete! 🎉"
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
