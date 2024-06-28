{ pkgs, ... }:
let
  nixr = if pkgs.system == "x86_64-linux" then
    "sudo nixos-rebuild switch --flake ~/nixos/#nixos"
  else if pkgs.system == "x86_64-darwin" then
    "~/result/sw/bin/darwin-rebuild switch --flake ./nixos#macbook"
  else
    "echo 'Unsupported system'";
in {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
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
}
