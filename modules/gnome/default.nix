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
    clipboard-indicator
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

  home-manager.users.skarv = { pkgs, ... }: {
    # Run dconf watch / to observe changes.
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
      };

      "org/gnome/settings-daemon/plugins/power".power-button-action = "suspend";

      "org/gnome/shell" = {
        favorite-apps = [
          "kitty.desktop"
          "firefox.desktop"
          "obsidian.desktop"
        ];
        enabled-extensions = [
          "blur-my-shell@aunetx"
          "caffeine@patapon.info"
          "logomenu@aryan_k"
          "quick-settings-tweaks@qwreey"
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "clipboard-indicator@tudmotu.com"
          "forge@jmmaranan.com"
        ];
      };

      "org/gnome/desktop/wm/preferences".num-workspaces = 6; # minimum number of workspaces.

      "org/gnome/shell/extensions/blur-my-shell" = with lib.gvariant;  {
        pipelines = [
          (mkDictionaryEntry "pipeline_default" ([
            (mkDictionaryEntry "name" (mkVariant "Default"))
            (mkDictionaryEntry "effects" (mkVariant [
              (mkVariant [
                (mkDictionaryEntry "type" (mkVariant "color"))
                (mkDictionaryEntry "id" (mkVariant "effect_000000000003"))
                (mkDictionaryEntry "params" (mkVariant [
                  (mkDictionaryEntry "color" (mkVariant ([
                    0.0816 0.2233 0.0759 0.4
                  ])))
                ]))
              ])
              (mkVariant [
                (mkDictionaryEntry "type" (mkVariant "native_static_gaussian_blur"))
                (mkDictionaryEntry "id" (mkVariant "effect_000000000000"))
                (mkDictionaryEntry "params" (mkVariant [
                  (mkDictionaryEntry "radius" (mkVariant 30.0))
                  (mkDictionaryEntry "brightness" (mkVariant 1.0))
                  (mkDictionaryEntry "unscaled_radius" (mkVariant 30.0))
                ]))
              ])
            ]))
          ]))

          (mkDictionaryEntry "pipeline_default_rounded" ([
            (mkDictionaryEntry "name" (mkVariant "Default rounded"))
            (mkDictionaryEntry "effects" (mkVariant [
              (mkVariant [
                (mkDictionaryEntry "type" (mkVariant "native_static_gaussian_blur"))
                (mkDictionaryEntry "id" (mkVariant "effect_000000000001"))
                (mkDictionaryEntry "params" (mkVariant [
                  (mkDictionaryEntry "radius" (mkVariant 30.0))
                  (mkDictionaryEntry "brightness" (mkVariant 0.6))
                ]))
              ])
              (mkVariant [
                (mkDictionaryEntry "type" (mkVariant "corner"))
                (mkDictionaryEntry "id" (mkVariant "effect_000000000002"))
                (mkDictionaryEntry "params" (mkVariant [
                  (mkDictionaryEntry "radius" (mkVariant 24.0))
                ]))
              ])
            ]))
          ]))
        ];
      };

      "org/gnome/shell/extensions/logo-menu" = {
        symbolic-icon = true;
        menu-button-icon-image = 23; # nixos logo
        use-custom-icon = false;
        menu-button-terminal = "kitty";
        hide-softwarecentre = true;
        show-activities-button = true; # Don't hide the workspace indicator.
      };

      "org/gnome/shell/extensions/forge" = {
        quick-settings-enabled = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
         switch-applications = [];
         switch-applications-backward = [];
         switch-windows = [ "<Alt>Tab" ];
         switch-windows-backward = [ "<Shift><Alt>Tab" ];
         switch-to-workspace-left = [ "<alt>left" ];
         switch-to-workspace-right = [ "<alt>right" ];
         switch-to-workspace-1 = [ "<alt>1" ];
         switch-to-workspace-2 = [ "<alt>2" ];
         switch-to-workspace-3 = [ "<alt>3" ];
         switch-to-workspace-4 = [ "<alt>4" ];
         switch-to-workspace-5 = [ "<alt>5" ];
         move-to-workspace-left = [ "<shift><alt>left" ];
         move-to-workspace-right = [ "<shift><alt>right" ];
         move-to-workspace-1 = [ "<shift><alt>1" ];
         move-to-workspace-2 = [ "<shift><alt>2" ];
         move-to-workspace-3 = [ "<shift><alt>3" ];
         move-to-workspace-4 = [ "<shift><alt>4" ];
         move-to-workspace-5 = [ "<shift><alt>5" ];
         move-to-monitor-left = [ "<super><alt>left" ];
         move-to-monitor-right = [ "<super><alt>right" ];
         close = [ "<super>q" "<alt>f4" ];
         toggle-fullscreen = [ "<super>f" ];      
      };
    };
  };
}
