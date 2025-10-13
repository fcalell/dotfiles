# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

Supports **macOS** (with Aerospace) and **Arch Linux** (with Hyprland).

## ✨ Features

- 🔄 **Cross-platform**: Same configs work on macOS and Arch Linux
- 📦 **Declarative**: All packages defined in a single source of truth
- 🚀 **Automated**: One-command setup for new machines
- 🎨 **Consistent**: Catppuccin Mocha theme everywhere
- ⚡ **Fast**: Optimized for performance

## 🛠️ What's Included

### Universal Tools
- **Shell**: zsh with zinit, modern CLI tools (eza, bat, fd, ripgrep, zoxide)
- **Editor**: Neovim with LSP, treesitter, and modern plugins
- **Terminal**: Kitty with Catppuccin theme
- **Git**: Enhanced with delta, lazygit
- **Version Manager**: mise for Node.js, Python, etc.

### Platform-Specific

#### macOS
- **Window Manager**: Aerospace (tiling WM)
- **Package Manager**: Homebrew

#### Arch Linux
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar
- **Launcher**: Wofi
- **Package Managers**: pacman + paru (AUR)

## 🚀 Quick Start

### New Machine Setup

Run this single command on a fresh macOS or Arch Linux install:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash
```

This will:
1. Detect your OS
2. Install prerequisites (Homebrew/pacman)
3. Install chezmoi
4. Clone and apply your dotfiles
5. Install all packages automatically

### Existing Setup

If you already have chezmoi and git:

```bash
# Initialize dotfiles
chezmoi init --apply YOUR_USERNAME

# Later, to update
chezmoi update
```

## 📁 Structure

```
~/.local/share/chezmoi/
├── install.sh                          # Bootstrap script
├── README.md                           # This file
├── .chezmoi.toml.tmpl                 # OS detection
├── .chezmoidata/
│   └── packages.toml                   # Unified package definitions
│
├── run_once_before_10-install-paru.sh.tmpl      # Install paru AUR helper (Linux)
├── run_once_before_20-install-packages.sh.tmpl  # Install all packages
├── run_once_after_30-setup-shell.sh.tmpl        # Configure shell (zsh, zinit)
├── run_once_after_40-install-mise-tools.sh.tmpl # Install mise tools (node, pnpm, etc)
├── run_once_after_50-setup-lazygit-config.sh.tmpl # Setup lazygit symlink (macOS)
│
├── dot_config/
│   ├── Brewfile.tmpl                  # macOS packages
│   ├── packages.txt.tmpl              # Arch official packages
│   ├── packages-aur.txt.tmpl          # Arch AUR packages
│   │
│   ├── nvim/                          # Neovim config (universal)
│   ├── kitty/                         # Kitty terminal (universal)
│   ├── lazygit/                       # Lazygit config (universal)
│   ├── mise/                          # Mise config (universal)
│   │
│   ├── aerospace/                     # macOS only
│   ├── hypr/                          # Linux only (Hyprland)
│   └── waybar/                        # Linux only
│
├── dot_zshrc.tmpl                     # Shell config
├── dot_zshenv.tmpl                    # Environment variables
└── dot_gitconfig                      # Git config
```

## 📦 Managing Packages

All packages are defined in `.chezmoidata/packages.toml`. Edit this file to add/remove packages:

```toml
# Standard package (same name on both platforms)
[packages.utilities.newtool]
macos.brew = "newtool"
linux.pacman = "newtool"

# Different package managers
[packages.utilities.special-tool]
macos.cask = "special-tool"      # Homebrew Cask for GUI apps
linux.aur = "special-tool-bin"   # AUR package

# Platform-specific
[packages.macos_only.some-app]
macos.cask = "some-app"

[packages.linux_only.some-tool]
linux.pacman = "some-tool"
```

Then apply changes:

```bash
chezmoi apply
```

The package lists (Brewfile, packages.txt) are automatically generated from this file.

## 🔧 Common Tasks

### Update Dotfiles

```bash
chezmoi update
```

### Edit Config Files

```bash
# Edit in source directory
chezmoi edit ~/.config/nvim/init.lua

# Apply changes
chezmoi apply
```

### Add New File

```bash
# Add file to chezmoi
chezmoi add ~/.config/new-tool/config.toml

# It's now tracked and will sync across machines
```

### Diff Changes

```bash
# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

### Re-run Setup Scripts

```bash
# Clear state and re-run
chezmoi state delete-bucket --bucket=scriptState

# Re-apply (will re-run scripts)
chezmoi apply
```

## 🎨 Customization

### Change Theme Colors

Edit the Catppuccin color values in:
- Kitty: `dot_config/kitty/kitty.conf`
- Neovim: `dot_config/nvim/lua/plugins/colorscheme.lua`
- Hyprland: `dot_config/hypr/hyprland.conf.tmpl`
- Waybar: `dot_config/waybar/style.css.tmpl`

### Platform-Specific Configs

Use chezmoi templates:

```bash
{{- if .is_macos }}
# macOS-specific config
{{- else if .is_linux }}
# Linux-specific config
{{- end }}
```

Available variables:
- `.is_macos` - true on macOS
- `.is_linux` - true on Linux
- `.is_arch` - true on Arch Linux
- `.os` - OS name (darwin/linux)
- `.hostname` - Machine hostname

## 🐛 Troubleshooting

### Package Installation Fails

**macOS:**
```bash
# Re-run Homebrew bundle
brew bundle --file=~/.config/Brewfile
```

**Arch Linux:**
```bash
# Update and re-install
sudo pacman -Syu
sudo pacman -S --needed - < ~/.config/packages.txt
paru -S --needed - < ~/.config/packages-aur.txt
```

### Chezmoi State Issues

```bash
# Reset chezmoi state
chezmoi state reset

# Re-apply everything
chezmoi apply --force
```

### Shell Not Using Zsh

```bash
# Manually set zsh as default
chsh -s $(which zsh)

# Restart terminal
```

## 📚 Documentation

- [chezmoi docs](https://www.chezmoi.io/)
- [chezmoi templates](https://www.chezmoi.io/user-guide/templating/)
- [Aerospace docs](https://nikitabobko.github.io/AeroSpace/guide)
- [Hyprland docs](https://wiki.hyprland.org/)

## 🤝 Contributing

Feel free to fork and customize for your own use!

## 📝 License

MIT

## 🙏 Credits

- Theme: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
- Managed with: [chezmoi](https://www.chezmoi.io/)
- Inspired by: NixOS/home-manager

---

**Happy dotfiling! 🎉**
