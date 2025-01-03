{
  programs.kitty = {
    enable = true;
    shellIntegration = { enableZshIntegration = true; };
    settings = {
      adjust_line_height = "120%";
      cursor_blink_interval = 0;
      hide_window_decorations = "titlebar-and-corners";
      # confirm_os_window_close = 0;
      clear_all_shortcuts = true;
      draw_minimal_borders = "yes";
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      bell_on_tab = false;
      window_padding_width = 5;
      macos_option_as_alt = "left";
    };
    keybindings = {
      "super+c" = "copy_to_clipboard";
      "super+v" = "paste_from_clipboard";
      "super+t" = "new_tab_with_cwd";
      "super+w" = "close_tab";
      "ctrl+tab" = "next_tab";
      "super+n" = "next_tab";
      "super+p" = "previous_tab";
      "super+plus" = "change_font_size all +2.0";
      "super+minus" = "change_font_size all -2.0";
    };
  };
  home.sessionVariables = { TERMINAL = "kitty"; };
}

