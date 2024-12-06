{ config, inputs, ... }: {
  imports = [ inputs.android-nixpkgs.hmModule ];
  android-sdk.enable = true;

  # Optional; default path is "~/.local/share/android".
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages = sdk:
    with sdk; [
      platform-tools
      build-tools-34-0-0
      cmdline-tools-latest
      emulator
      platforms-android-34
      sources-android-34
      system-images-android-34-default-x86-64
    ];
  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.home.homeDirectory}/.android";
    ANDROID_EMULATOR_HOME = "${config.home.homeDirectory}/.android";
    ANDROID_AVD_HOME = "${config.home.homeDirectory}/.android/avd";
  };
}
