{ ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family      JetBrainsMono Nerd Font
      bold_font        JetBrainsMono Nerd Font 
      italic_font      JetBrainsMono Nerd Font
      bold_italic_font JetBrainsMono Nerd Font
      font_size 12.0
      modify_font underline_position 2
      modify_font underline_thickness 150%
      adjust_line_height  120%

      cursor_blink_interval 0

      window_padding_width 2
      background_opacity 0.98
      background #000000

      macos_option_as_alt left
      macos_show_window_title_in none
      open_url_modifiers super

      clear_all_shortcuts yes
      map super+c copy_to_clipboard
      map super+v paste_from_clipboard

      map super+t new_tab_with_cwd
      map super+w close_tab
      map ctrl+tab next_tab
      map super+n next_tab
      map super+p previous_tab

      map super+plus change_font_size all +2.0
      map super+minus change_font_size all -2.0
      map super+shift+r load_config_file

      foreground #a9b1d6
      background #1a1b26

      # Black
      color0 #414868
      color8 #414868
      # Red
      color1 #f7768e
      color9 #f7768e
      # Green
      color2  #73daca
      color10 #73daca
      # Yellow
      color3  #e0af68
      color11 #e0af68
      # Blue
      color4  #7aa2f7
      color12 #7aa2f7
      # Magenta
      color5  #bb9af7
      color13 #bb9af7
      # Cyan
      color6  #7dcfff
      color14 #7dcfff
      # White
      color7  #c0caf5
      color15 #c0caf5

      # Cursor
      cursor #c0caf5
      cursor_text_color #1a1b26

      # Selection highlight
      selection_foreground none
      selection_background #28344a

      # The color for highlighting URLs on mouse-over
      url_color #9ece6a

      # Window borders
      active_border_color #3d59a1
      inactive_border_color #101014
      bell_border_color #e0af68

      # Tab bar
      tab_bar_style fade
      tab_fade 1
      active_tab_foreground   #3d59a1
      active_tab_background   #16161e
      active_tab_font_style   bold
      inactive_tab_foreground #787c99
      inactive_tab_background #16161e
      inactive_tab_font_style bold
      tab_bar_background #101014

      # Title bar
      macos_titlebar_color #16161e
    '';
  };
}
