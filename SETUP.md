# Setup Guide

Step-by-step guide for setting up these dotfiles on a new machine.

## Prerequisites

- macOS 12+ or Arch Linux
- Internet connection
- Terminal access

## Installation Methods

### Method 1: One-Command Bootstrap (Recommended)

This is the easiest way to set up a new machine:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash
```

**What it does:**
1. Detects your OS (macOS or Arch Linux)
2. Installs package manager (Homebrew or updates pacman)
3. Installs chezmoi
4. Prompts for your GitHub username
5. Clones and applies your dotfiles
6. Runs automated setup scripts in order:
   - **10**: Install paru (Linux only)
   - **20**: Install all packages (brew/pacman/paru)
   - **30**: Setup shell (zsh, zinit, systemd services)
   - **40**: Install mise tools (node, pnpm, uv, etc)
   - **50**: Setup lazygit config symlink (macOS only)

### Method 2: Manual Installation

If you prefer more control:

#### On macOS:

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi
brew install chezmoi

# Initialize dotfiles
chezmoi init --apply YOUR_USERNAME
```

#### On Arch Linux:

```bash
# Update system
sudo pacman -Syu

# Install base tools
sudo pacman -S --needed base-devel git chezmoi

# Initialize dotfiles
chezmoi init --apply YOUR_USERNAME
```

## Post-Installation

### 1. Restart Your Shell

```bash
exec $SHELL
```

Or close and reopen your terminal.

### 2. Verify Installation

Check that everything is working:

```bash
# Check shell
echo $SHELL  # Should be /bin/zsh or /usr/bin/zsh

# Check package manager
brew --version    # macOS
pacman --version  # Linux

# Check tools
nvim --version
fzf --version
bat --version
```

### 3. macOS Specific

If on macOS, verify Aerospace is running:

```bash
# Check if Aerospace is running
ps aux | grep -i aerospace
```

Keybindings:
- `Cmd+H/J/K/L` - Focus windows
- `Cmd+Shift+H/J/K/L` - Move windows
- `Cmd+1-5` - Switch workspaces
- `Cmd+Shift+1-5` - Move window to workspace

### 4. Linux Specific

If on Arch Linux, start Hyprland:

```bash
# From TTY (after login)
Hyprland
```

Or set up a display manager for automatic login.

Keybindings:
- `Super+Return` - Open terminal
- `Super+D` - Application launcher (wofi)
- `Super+Q` - Close window
- `Super+H/J/K/L` - Focus windows
- `Super+1-5` - Switch workspaces

## Customization

### Adding a New Package

1. Edit `.chezmoidata/packages.toml`:

```toml
[packages.utilities.my-new-tool]
macos.brew = "brew-name"
linux.pacman = "arch-package-name"
```

2. Apply changes:

```bash
chezmoi apply
```

This regenerates the package lists and you can install with:

```bash
# macOS
brew bundle --file=~/.config/Brewfile

# Linux
sudo pacman -S --needed - < ~/.config/packages.txt
```

### Editing Configs

```bash
# Edit in chezmoi source directory
chezmoi edit ~/.config/nvim/init.lua

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

### Adding OS-Specific Configuration

Use chezmoi templates with conditionals:

```bash
{{- if .is_macos }}
# macOS-specific config
{{- else if .is_linux }}
# Linux-specific config
{{- end }}
```

## Updating Dotfiles

### Pull Latest Changes

```bash
chezmoi update
```

This pulls from git and applies changes.

### Push Your Changes

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Update configs"
git push
```

Or use the helper:

```bash
chezmoi cd
git add .
git commit -m "Update configs"
git push
exit
```

## Troubleshooting

### Packages Not Installing

**macOS:**
```bash
brew bundle --file=~/.config/Brewfile --force
```

**Linux:**
```bash
sudo pacman -Syu
sudo pacman -S --needed --force - < ~/.config/packages.txt
```

### Run Scripts Not Executing

Clear chezmoi state to force re-run:

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Shell Not Zsh

Manually change default shell:

```bash
chsh -s $(which zsh)
```

Then restart terminal.

### Hyprland Not Starting (Linux)

Check logs:

```bash
cat ~/.local/share/hyprland/hyprland.log
```

Common issues:
- Missing drivers: `sudo pacman -S mesa xf86-video-amdgpu` (or nvidia/intel)
- Missing portal: `sudo pacman -S xdg-desktop-portal-hyprland`

### Neovim Errors

Reinstall plugins:

```bash
nvim
# In nvim:
:Lazy sync
```

## Advanced

### Multiple Machines with Different Configs

Use chezmoi's data feature:

1. Create `.chezmoi.toml.tmpl` with machine-specific data
2. Use conditionals based on hostname:

```toml
{{- if eq .hostname "work-laptop" }}
# Work-specific config
{{- else }}
# Personal config
{{- end }}
```

### Secrets Management

Use chezmoi's secret management:

```bash
# Store secret
chezmoi secret set API_KEY

# Use in template
{{ .secrets.API_KEY }}
```

Or use external tools like:
- 1Password: `op` CLI
- pass: Unix password manager
- Age: Modern encryption tool

### Backing Up

Your dotfiles are in git, but to backup system state:

```bash
# Export package lists
brew bundle dump --file=~/backup-Brewfile  # macOS
pacman -Qqe > ~/backup-packages.txt        # Linux
```

## Getting Help

- **Chezmoi Issues**: https://github.com/twpayne/chezmoi/issues
- **Neovim Configs**: Check `:help` in Neovim
- **Aerospace**: https://nikitabobko.github.io/AeroSpace/
- **Hyprland**: https://wiki.hyprland.org/

## Next Steps

1. Customize keybindings to your preference
2. Add your personal tools/packages
3. Configure mise tools: `mise use node@lts`
4. Set up your development environment
5. Enjoy your new setup! 🎉
