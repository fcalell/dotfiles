{
  programs.waybar.style = ''
    * {
        min-height: 0;
        font-size: 14px;
        font-weight: bold;
    }

    window#waybar {
        /* background: rgba(16, 18, 19, 0.8); */
        background-color: transparent;
    }

    #workspaces button {
        margin: 2px 3px;
        color: #cdd6f4;
        background-color: #1e1e2e;
        border-bottom: 2px solid transparent;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button.active {
        border-radius: 0px;
        border-bottom: 2px solid @pink;
        transition: all 0.3s ease-in-out;
    }

    #pulseaudio, #clock, #workspaces {
        margin: 5px 5px 0px 5px;
        border-radius: 10px 24px 10px 24px;
        padding: 0 20px;
        background-color: #1e1e2e;
    }
  '';
}
