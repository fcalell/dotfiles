{ inputs, ... }: {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "mocha";
    pointerCursor = {
      enable = true;
      accent = "dark";
      flavor = "mocha";
    };
  };
}
