{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        anchor = "center";
        layer = "overlay";
        font = "Noto Sans:size=14";
        prompt = "❯ ";
        lines = "3";
        width = "40";
        vertical-pad = "12";
        inner-pad = "8";
      };
      border = {
        radius = "12";
        width = "3";
      };
    };
  };
}
