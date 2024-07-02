{ pkgs, username, ... }: {
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.${username}.useDefaultShell = true;
}
