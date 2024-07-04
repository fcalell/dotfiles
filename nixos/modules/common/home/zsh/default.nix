{ pkgs, ... }:
let
  nixr = if pkgs.system == "x86_64-linux" then
    "sudo nixos-rebuild switch --flake ~/nixos/#nixos"
  else if pkgs.system == "aarch64-darwin" then
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
      antidote = {
        enable = true;
        plugins = [
          # "spaceship-prompt/spaceship-prompt"
          # "spaceship-prompt/spaceship-vi-mode"
          "romkatv/powerlevel10k"
        ];
      };
      initExtra = ''
        source ~/.p10k.zsh
      '';
      shellAliases = {
        nixr = nixr;
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
  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
