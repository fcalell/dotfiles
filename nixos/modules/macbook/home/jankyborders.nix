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
  launchd.user.agents.jankyborders = {
    serviceConfig.ProgramArguments = [ "${cfg.package}/bin/borders" ]
      ++ (optionalArg "width" (toString cfg.width))
      ++ (optionalArg "hidpi" (if cfg.hidpi then "on" else "off"))
      ++ (optionalArg "active_color" cfg.active_color)
      ++ (optionalArg "inactive_color" cfg.inactive_color)
      ++ (optionalArg "background_color" cfg.background_color)
      ++ (optionalArg "style" cfg.style)
      ++ (optionalArg "blur_radius" (toString cfg.blur_radius))
      ++ (optionalArg "ax_focus" (if cfg.ax_focus then "on" else "off"))
      ++ (optionalArg "order" cfg.order);
    serviceConfig.KeepAlive = true;
    serviceConfig.RunAtLoad = true;
  };
}
