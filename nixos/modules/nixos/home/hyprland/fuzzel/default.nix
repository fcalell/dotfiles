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
      colors = {
        background = "1e1e2efa";
        text = "cdd6f4ff";
        selection = "6c7086b3";
        selection-text = "cdd6f4ff";
        selection-match = "cdd6f4ff";
        border = "89b4faff";
      };
      border = {
        radius = "12";
        width = "3";
      };
    };
  };
}
