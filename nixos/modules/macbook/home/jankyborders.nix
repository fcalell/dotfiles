{ pkgs, lib, ... }:
let
  cfg = {
    active_color = "0xFFB4BEFE";
    inactive_color = "0xFF6C7086";
    order = "above";
    width = 5.0;
  };

  optionalArg = arg: value:
    if value != null && value != "" then
      if lib.isList value then
        lib.map (val: "${arg}=${val}") value
      else
        [ "${arg}=${value}" ]
    else
      [ ];
in {
  home.packages = with pkgs; [ jankyborders ];
  launchd.agents.jankyborders = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.jankyborders}/bin/borders" ]
        ++ (optionalArg "width" (toString cfg.width))
        ++ (optionalArg "active_color" cfg.active_color)
        ++ (optionalArg "inactive_color" cfg.inactive_color)
        ++ (optionalArg "order" cfg.order);
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
