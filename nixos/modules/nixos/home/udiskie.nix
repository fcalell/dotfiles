{
  udisks2.enable = true;
  services.udiskie = {
    enable = true;
    automount = true;
    tray = "always";
    notify = true;
  };
}
