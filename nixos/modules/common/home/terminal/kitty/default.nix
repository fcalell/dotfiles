{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };
    # theme = "Catppuccin-Mocha";
    settings = {
      # modify_font underline_position 2
      # modify_font underline_thickness 150%
      adjust_line_height = "120%";
      text_composition_strategy = "platform";
      sync_to_monitor = "yes";

      # cursor_shape = "block";
      cursor_blink_interval = 0;

      # confirm_os_window_close = 0;
      disable_ligatures = "never";

      copy_on_select = "clipboard";
      clear_all_shortcuts = true;
      draw_minimal_borders = "yes";
      input_delay = 0;
      # kitty_mod = "ctrl+shift";

      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      bell_on_tab = false;
      command_on_bell = "none";

      term = "xterm-256color";

      window_padding_width = 5;

      macos_option_as_alt = "left";
      macos_show_window_title_in = "none";

      # Tab Bar
      # tab_bar_edge = "top";
      # tab_bar_margin_width = 5;
      # tab_bar_margin_height = "5 0";
      # tab_bar_style = "separator";
      # tab_bar_min_tabs = 2;
      # tab_separator = "";
      # tab_title_template = "{fmt.fg._5c6370}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._5c6370} {tab.active_oldest_wd} {fmt.fg._5c6370}{fmt.bg.default} ";
      # active_tab_title_template = "{fmt.fg._BAA0E8}{fmt.bg.default}{fmt.fg.default}{fmt.bg._BAA0E8} {tab.active_oldest_wd} {fmt.fg._BAA0E8}{fmt.bg.default} ";
      # tab_bar_edge = "bottom";
      # tab_bar_style = "powerline";
      # tab_powerline_style = "slanted";
      # active_tab_title_template = "{index}: {title}";
      # active_tab_font_style = "bold-italic";
      # inactive_tab_font_style = "normal";

      # repaint_delay = 8;
    };
    extraConfig = ''
      map super+c copy_to_clipboard
      map super+v paste_from_clipboard

      map super+t new_tab_with_cwd
      map super+w close_tab
      map ctrl+tab next_tab
      map super+n next_tab
      map super+p previous_tab

      map super+plus change_font_size all +2.0
      map super+minus change_font_size all -2.0
    '';
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
    TERM = "kitty";
  };
}

