{ config, lib, pkgs, inputs, ... }:

{
  imports = [
  ];

  # dconf.settings = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  #
  #   # You need quotes to escape '/'
  #   "org/gnome/desktop/interface" = {
  #     clock-show-weekday = true;
  #   };    
  # };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    totem # video player
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gedit # text editor
    # gnome-contacts
    # gnome-maps
    # gnome-music
  ];

  hardware.sensor.iio.enable = true; # automatic screen rotation

  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    pop-shell
    quick-settings-tweaker
    top-bar-organizer
    just-perfection
    caffeine
    open-bar
    space-bar
    logo-menu
    # coverflow-alt-tab
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
