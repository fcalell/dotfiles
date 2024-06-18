{
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0px;
        min-height: 0;
    }

    window#waybar {
        /* background: rgba(16, 18, 19, 0.8); */
        background-color: transparent;
    }

    #workspaces {
        margin: 5px 5px;
        padding: 8px 5px;
        border-radius: 16px;
    }
    #workspaces button {
        padding: 0px 5px;
        margin: 0px 3px;
        border-radius: 16px;
        color: transparent;
        background-color: #2f354a;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button.active {
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button:hover {
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
    }

     #pulseaudio, #clock {
        font-weight: bold;
        margin: 5px 0px;
        border-radius: 10px 24px 10px 24px;
        padding: 0 20px;
        margin-left: 7px;
    }
    #clock {
      margin-right: 5px;
    }
    #window{
        padding-left: 15px;
        padding-right: 15px;
        border-radius: 16px;
        margin-top: 5px;
        margin-bottom: 5px;
        font-weight: normal;
        font-style: normal;
    }
  '';
}
