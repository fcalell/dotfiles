{ config, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultfonts = {
      serif = [ config.theme.fonts.serif.name ];
      sansSerif = [ config.theme.fonts.sansSerif.name ];
      monospace = [ config.theme.fonts.monospace.name ];
      emoji = [ config.theme.fonts.emoji.name ];
    };
  };
}
