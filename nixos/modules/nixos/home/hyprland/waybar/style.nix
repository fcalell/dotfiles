_:
let
  font = "DroidSansMono Nerd Font";
  primary_accent = "cba6f7";
  secondary_accent = "89b4fa";
  tertiary_accent = "f5f5f5";
  background = "11111B";
in {
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0px;
        font-family: ${font};
        font-size: 14px;
        min-height: 0;
        color: #${tertiary_accent};
    }

    window#waybar {
        /* background: rgba(16, 18, 19, 0.8); */
        background-color: transparent;
    }

    #cava.left, #cava.right {
        background: #${background};
        margin: 5px;
        padding: 8px 16px;
        color: #${primary_accent};
    }
    #cava.left {
        border-radius: 24px 10px 24px 10px;
    }
    #cava.right {
        border-radius: 10px 24px 10px 24px;
    }
    #workspaces {
        background: #${background};
        margin: 5px 5px;
        padding: 8px 5px;
        border-radius: 16px;
        color: #${primary_accent}
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
        background-color: #${secondary_accent};
        color: #${background};
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
        transition: all 0.3s ease-in-out;
    }

    #workspaces button:hover {
        background-color: #${tertiary_accent};
        color: #${background};
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
    }

     #pulseaudio, #clock {
        background: #${background};
        font-weight: bold;
        margin: 5px 0px;
        border-radius: 10px 24px 10px 24px;
        padding: 0 20px;
        margin-left: 7px;
    }
    # pulseaudio {
      color: #${primary_accent};
    }
    #clock {
      color: #${tertiary_accent};
      margin-right: 5px;
    }
    #window{
        background: #${background};
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
