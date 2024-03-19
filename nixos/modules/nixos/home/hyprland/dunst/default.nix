_: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "DroidSansMono Nerd Font 12";
        frame_color = "#89B4FA";
        separator_color = "frame";
        icon_position = "left";
        corner_radius = 8;
        text_icon_padding = 8;
        frame_width = 1;
      };
      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
      };
      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
      };
      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#FAB387";
      };
    };
  };
}
