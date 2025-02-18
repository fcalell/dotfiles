{
  imports = [
    "${
      builtins.fetchGit { url = "https://github.com/antithesishq/madness.git"; }
    }/modules"
  ];
  madness.enable = true;
}
