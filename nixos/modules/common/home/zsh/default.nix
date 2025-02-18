{ pkgs, ... }: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      initExtra = ''
        source ~/.p10k.zsh
        check_and_rebuild() {
          if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "Detected Linux environment."
            sudo nixos-rebuild switch --flake ~/nixos/#nixos
          elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Detected macOS environment."
            darwin-rebuild switch --flake ~/nixos/#macbook
          else
            echo "Unsupported OS type: $OSTYPE"
          fi
        }
        android_emulator() {
          # Check if steam-run is installed (i.e., available in PATH)
          if command -v steam-run >/dev/null 2>&1; then
              # If steam-run is found, run emulator using steam-run
              exec steam-run emulator "$@"
          else
              # If steam-run is not found, run emulator directly
              exec emulator "$@"
          fi
        }
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      '';
      shellAliases = {
        nixr = "check_and_rebuild";
        nixc = "sudo nix-collect-garbage -d";
        gg = "lazygit";
        ls = "ls --color -la -h";
        ".." = "cd ..";
        cl = "clear";
        top = "btop";
        df = "duf";
        du = "dust";
        # emulator = "android_emulator";
      };
    };
  };
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
