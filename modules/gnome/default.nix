{ config, lib, pkgs, inputs, ... }:

{
  imports = [
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    totem # video player
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gedit # text editor
    gnome-contacts
    gnome-maps
    gnome-music
  ];

  hardware.sensor.iio.enable = true; # automatic screen rotation

  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    pop-shell
    quick-settings-tweaker
    rounded-window-corners-reborn
    clipboard-indicator
    # tiling-shell
    caffeine
    logo-menu
    launch-new-instance
    forge
  ];
  
  services = {
    gnome = {

    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

}
