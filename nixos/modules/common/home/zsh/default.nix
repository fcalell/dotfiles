{ pkgs, ... }: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      plugins = [{
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }];
      initContent = ''
        source ~/.p10k.zsh
        source ~/.env.zsh
        source ~/.path.zsh
        check_and_rebuild() {
          if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "Detected Linux environment."
            sudo nixos-rebuild switch --flake ~/nixos/#nixos
          elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Detected macOS environment."
            sudo darwin-rebuild switch --flake ~/nixos/#macbook
          else
            echo "Unsupported OS type: $OSTYPE"
          fi
        }
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      '';
      shellAliases = {
        nixr = "check_and_rebuild";
        nixc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
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
  home.file.".path.zsh".source = ./path.zsh;
}
