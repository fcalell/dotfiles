{ system, ... }:
let
  nixr = if system == "x86_64-linux" then
    "sudo nixos-rebuild switch --flake ~/nixos/#main_pc"
  else if system == "x86_64-darwin" then
    "~/result/sw/bin/darwin-rebuild switch --flake ./nixos#macbook"
  else
    "echo 'Unsupported system'";
in {
  programs = {
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "gallois";
        plugins = [ "git" ];
      };
      enableAutosuggestions = true;
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
        note = "cd ~/Documents/notes && vi index.norg";
      };
    };
  };
}
