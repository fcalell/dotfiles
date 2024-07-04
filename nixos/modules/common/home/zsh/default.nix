{ system, pkgs, ... }:
let
  nixr = if system == "x86_64-linux" then
    "sudo nixos-rebuild switch --flake ~/nixos/#nixos"
  else if system == "aarch64-darwin" then
    "nix run nix-darwin -- switch --flake ~/nixos/.#macbook"
  else
    "echo 'Unsupported system'";
in {
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
      };
    };
  };
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
