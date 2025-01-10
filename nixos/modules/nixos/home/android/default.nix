{ config, inputs, pkgs, ... }: {
  imports = [ inputs.android-nixpkgs.hmModule ];
  android-sdk.enable = true;

  # Optional; default path is "~/.local/share/android".
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages = sdk:
    with sdk; [
      platform-tools
      build-tools-35-0-0
      build-tools-34-0-0
      cmdline-tools-latest
      emulator
      platforms-android-35
      sources-android-35
      system-images-android-35-default-x86-64
      system-images-android-35-google-apis-playstore-x86-64
      ndk-26-1-10909125
      skiaparser-3
      sources-android-34
      cmake-3-22-1
    ];

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };
  programs.gradle = {
    enable = true;
    settings = { newArchEnables = true; };
  };

  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.home.homeDirectory}/.android";
    ANDROID_EMULATOR_HOME = "${config.home.homeDirectory}/.android";
    ANDROID_AVD_HOME = "${config.home.homeDirectory}/.android/avd";
  };
}
