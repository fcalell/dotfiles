{
  programs.waybar.style = ''
    * {
        min-height: 0;
        font-size: 14px;
        font-weight: bold;
        color: @text;
    }

    window#waybar {
        /* background: rgba(16, 18, 19, 0.8); */
        background-color: transparent;
    }

    #workspaces button {
        margin: 2px 3px;
        border-radius: 0px;
        border-bottom: 2px solid transparent;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button.active {
        border-radius: 0px;
        border-bottom: 2px solid @blue;
        transition: all 0.3s ease-in-out;
    }

    #pulseaudio, #clock, #tray, #workspaces, #window {
        margin: 5px 5px 0px 5px;
        border-radius: 10px 24px 10px 24px;
        padding: 0 20px;
        background-color: @base;
    }
  '';
}
