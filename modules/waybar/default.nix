{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = (builtins.readFile ./style.css);
    };

    xdg.configFile."waybar/config".source = ./config.default;

}
