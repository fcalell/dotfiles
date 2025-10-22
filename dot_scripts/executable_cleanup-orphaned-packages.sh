#!/bin/bash

# Manual script to cleanup packages installed but not defined in packages.toml
# This compares installed packages from each package manager with packages.toml
# and helps remove orphaned packages or add them to the configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Package Manager Cleanup Tool ===${NC}\n"

# Packages to always exclude from orphan detection (critical system packages)
EXCLUDE_PACKAGES=(
    "paru"
    "paru-bin"
    "paru-debug"
    "yay"
    "yay-bin"
    "yay-git"
)

# Determine OS and package managers
PACKAGES_TOML="${HOME}/.local/share/chezmoi/.chezmoidata/packages.toml"
if [[ ! -f "$PACKAGES_TOML" ]]; then
    echo -e "${RED}Error: packages.toml not found at $PACKAGES_TOML${NC}"
    exit 1
fi

# Extract defined package names from packages.toml (section headers)
DEFINED_PACKAGES=$(grep -E '^\[.*\]$' "$PACKAGES_TOML" | sed 's/\[\(.*\)\]/\1/' | sort -u)

echo -e "${CYAN}Defined packages in packages.toml: $(echo "$DEFINED_PACKAGES" | wc -l)${NC}\n"

# Function to process package manager
process_package_manager() {
    local pm_name=$1
    local pm_command=$2
    local pm_key=$3  # The key in packages.toml (e.g., "linux.pacman", "linux.aur", "macos.brew")

    echo -e "${YELLOW}=== Checking $pm_name ===${NC}"

    # Check if package manager exists
    if ! command -v $pm_command &> /dev/null; then
        echo -e "${BLUE}$pm_command not found, skipping${NC}\n"
        return
    fi

    # Get list of explicitly installed packages
    local installed_packages
    case "$pm_name" in
        "Pacman (official)")
            # Get explicitly installed packages from official repos only
            installed_packages=$(pacman -Qqe | while read pkg; do
                if pacman -Qi "$pkg" 2>/dev/null | grep -q "Repository.*:.*core\|extra\|multilib"; then
                    echo "$pkg"
                fi
            done | sort)
            ;;
        "AUR (paru/yay)")
            # Get explicitly installed AUR packages
            installed_packages=$(pacman -Qqem | sort)
            ;;
        "Homebrew")
            # Get explicitly installed homebrew packages (leaves)
            installed_packages=$(brew leaves 2>/dev/null | sort)
            ;;
        "Homebrew Cask")
            # Get explicitly installed casks
            installed_packages=$(brew list --cask 2>/dev/null | sort)
            ;;
        *)
            echo -e "${RED}Unknown package manager: $pm_name${NC}\n"
            return
            ;;
    esac

    if [[ -z "$installed_packages" ]]; then
        echo -e "${GREEN}No packages found${NC}\n"
        return
    fi

    # Extract actual package names from packages.toml for this package manager
    # This gets the actual package names from lines like: linux.aur = "package-name"
    local toml_packages=$(grep "$pm_key = " "$PACKAGES_TOML" | sed 's/.*= "\(.*\)"/\1/' | sort -u)

    # Find orphaned packages (installed but not in packages.toml)
    local orphaned=()
    while IFS= read -r pkg; do
        # Check if package is in toml_packages
        if echo "$toml_packages" | grep -q "^${pkg}$"; then
            continue
        fi

        # Check if package is in exclusion list
        local excluded=false
        for excl in "${EXCLUDE_PACKAGES[@]}"; do
            if [[ "$pkg" == "$excl" ]]; then
                excluded=true
                break
            fi
        done

        if [[ "$excluded" == false ]]; then
            orphaned+=("$pkg")
        fi
    done <<< "$installed_packages"

    local total_installed=$(echo "$installed_packages" | wc -l)
    local total_orphaned=${#orphaned[@]}

    echo -e "${CYAN}Total installed: $total_installed${NC}"
    echo -e "${CYAN}Defined in packages.toml: $(echo "$toml_packages" | wc -l)${NC}"
    echo -e "${YELLOW}Orphaned (not in packages.toml): $total_orphaned${NC}\n"

    if [[ $total_orphaned -eq 0 ]]; then
        echo -e "${GREEN}✓ No orphaned packages!${NC}\n"
        return
    fi

    # Show orphaned packages
    echo -e "${RED}Orphaned packages:${NC}"
    for pkg in "${orphaned[@]}"; do
        echo -e "  ${RED}•${NC} $pkg"
    done
    echo ""

    # Interactive menu
    while true; do
        echo -e "${YELLOW}What would you like to do with these orphaned packages?${NC}"
        echo "  1) Uninstall all orphaned packages"
        echo "  2) Add all to packages.toml"
        echo "  3) Review each package individually"
        echo "  4) Show package details"
        echo "  5) Skip (continue to next package manager)"
        echo ""
        read -p "Enter choice [1-5]: " choice

        case $choice in
            1)
                echo -e "\n${YELLOW}Uninstalling orphaned packages...${NC}"
                case "$pm_name" in
                    "Pacman (official)")
                        sudo pacman -Rns "${orphaned[@]}"
                        ;;
                    "AUR (paru/yay)")
                        sudo pacman -Rns "${orphaned[@]}"
                        ;;
                    "Homebrew")
                        brew uninstall "${orphaned[@]}"
                        ;;
                    "Homebrew Cask")
                        brew uninstall --cask "${orphaned[@]}"
                        ;;
                esac
                echo -e "${GREEN}✓ Packages uninstalled${NC}\n"
                break
                ;;
            2)
                echo -e "\n${YELLOW}Adding packages to packages.toml...${NC}"
                for pkg in "${orphaned[@]}"; do
                    echo "" >> "$PACKAGES_TOML"
                    echo "[$pkg]" >> "$PACKAGES_TOML"
                    echo "$pm_key = \"$pkg\"" >> "$PACKAGES_TOML"
                    echo -e "${GREEN}✓ Added $pkg${NC}"
                done
                echo -e "\n${GREEN}✓ All packages added${NC}"
                echo -e "${BLUE}Note: Consider organizing these entries in packages.toml${NC}\n"
                break
                ;;
            3)
                echo -e "\n${YELLOW}Reviewing packages individually...${NC}\n"
                for pkg in "${orphaned[@]}"; do
                    echo -e "${CYAN}=== Package: $pkg ===${NC}"

                    # Show brief info
                    case "$pm_name" in
                        "Pacman (official)"|"AUR (paru/yay)")
                            pacman -Qi "$pkg" 2>/dev/null | grep -E "^(Description|Installed Size)" || true
                            ;;
                        "Homebrew"|"Homebrew Cask")
                            brew info "$pkg" 2>/dev/null | head -3 || true
                            ;;
                    esac

                    echo ""
                    while true; do
                        read -p "Action for $pkg? [u]ninstall, [a]dd to packages.toml, [s]kip: " action
                        case "$action" in
                            u|U)
                                case "$pm_name" in
                                    "Pacman (official)"|"AUR (paru/yay)")
                                        sudo pacman -Rns "$pkg"
                                        ;;
                                    "Homebrew")
                                        brew uninstall "$pkg"
                                        ;;
                                    "Homebrew Cask")
                                        brew uninstall --cask "$pkg"
                                        ;;
                                esac
                                echo -e "${GREEN}✓ Uninstalled $pkg${NC}\n"
                                break
                                ;;
                            a|A)
                                echo "" >> "$PACKAGES_TOML"
                                echo "[$pkg]" >> "$PACKAGES_TOML"
                                echo "$pm_key = \"$pkg\"" >> "$PACKAGES_TOML"
                                echo -e "${GREEN}✓ Added $pkg to packages.toml${NC}\n"
                                break
                                ;;
                            s|S)
                                echo -e "${BLUE}Skipped $pkg${NC}\n"
                                break
                                ;;
                            *)
                                echo -e "${RED}Invalid choice. Please enter u, a, or s${NC}"
                                ;;
                        esac
                    done
                done
                break
                ;;
            4)
                echo -e "\n${BLUE}Package Details:${NC}\n"
                for pkg in "${orphaned[@]}"; do
                    echo -e "${YELLOW}=== $pkg ===${NC}"
                    case "$pm_name" in
                        "Pacman (official)"|"AUR (paru/yay)")
                            pacman -Qi "$pkg" 2>/dev/null | grep -E "^(Name|Description|Installed Size|Depends On|Required By)" || true
                            ;;
                        "Homebrew"|"Homebrew Cask")
                            brew info "$pkg" 2>/dev/null || true
                            ;;
                    esac
                    echo ""
                done
                ;;
            5)
                echo -e "${BLUE}Skipping to next package manager${NC}\n"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-5${NC}\n"
                ;;
        esac
    done
}

# Process each package manager based on OS
if [[ "$(uname)" == "Linux" ]]; then
    # Check for Arch Linux
    if command -v pacman &> /dev/null; then
        process_package_manager "Pacman (official)" "pacman" "linux.pacman"

        # Check for AUR helper
        if command -v paru &> /dev/null || command -v yay &> /dev/null; then
            process_package_manager "AUR (paru/yay)" "pacman" "linux.aur"
        fi
    fi
elif [[ "$(uname)" == "Darwin" ]]; then
    # macOS with Homebrew
    if command -v brew &> /dev/null; then
        process_package_manager "Homebrew" "brew" "macos.brew"
        process_package_manager "Homebrew Cask" "brew" "macos.cask"
    fi
fi

echo -e "${GREEN}=== Cleanup Complete ===${NC}"
echo -e "${BLUE}Remember to run 'chezmoi apply' if you modified packages.toml${NC}"
