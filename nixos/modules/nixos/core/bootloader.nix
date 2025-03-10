{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    timeout = 0;
    efi.canTouchEfiVariables = true;
  };
  boot.consoleLogLevel = 3;
}
