{ config, lib, pkgs, ... }:

{
  imports = [];

  options.dev = {
    enable = lib.mkEnableOption "Enable Development.";

    environments = {
      c = {
        enable = lib.mkEnableOption "Enable C Development.";
      };
      android = {
        enable = lib.mkEnableOption "Enable Android Development.";
      };
      python = {
        enable = lib.mkEnableOption "Enable Python Development";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.dev.enable {
      home.packages = with pkgs; [
        git
      ];

      programs.git = {
        enable = true;
        extraConfig = {
          core.editor = "nvim";
          user = {
            email = "simon.alveteg@gmail.com";
            name = "simonalveteg";
          };
          init = {defaultBranch = "main";};
        };
        aliases = {
          cam = "commit -a -m";
          clo = "config --list --show-origin";
          l = "log --oneline -n10";
        };
      };
    })

    (lib.mkIf config.dev.environments.c.enable {
      home.packages = with pkgs; [
        gcc
        gdb
        oprofile
        valgrind
        gnumake
      ];
     })

    (lib.mkIf config.dev.environments.android.enable {
      home.packages = with pkgs; [];
     })
  ];
}
