{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "24.05"; 
  home.username = "skarv";
  home.homeDirectory = "/home/skarv";

  imports = [
    inputs.nvchad4nix.homeManagerModule
    ../../modules/nvchad
    ../../modules/dev
  ];

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
        # "tilingshell@ferrarodomenico.com" 
        "clipboard-indicator@tudmotu.com"
        "forge@jmmaranan.com"
      ];
    };
    # "org/gnome/mutter".edge-tiling = true; # not needed when tilingshell is enabled.
    "org/gnome/desktop/wm/preferences".num-workspaces = 6; # minimum number of workspaces.
    # Can't figure out why this doesn't work.
    # "org/gnome/shell/extensions/blur-my-shell" = {
    #   pipelines = ''{'pipeline_default': {'name': <'Default'>, 'effects': <[<{'type': <'color'>, 'id': <'effect_39989179920848'>, 'params': <{'color': <(0.12852799892425537, 0.28999999165534973, 0.065733335912227631, 0.46666666865348816)>}>}>, <{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000000'>, 'params': <{'radius': <30>, 'brightness': <0.59999999999999998>}>}>]>}, 'pipeline_default_rounded': {'name': <'Default rounded'>, 'effects': <[<{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000001'>, 'params': <{'radius': <30>, 'brightness': <0.59999999999999998>}>}>, <{'type': <'corner'>, 'id': <'effect_000000000002'>, 'params': <{'radius': <24>}>}>]>}}'';
    # };
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
    # "org/gnome/shell/extensions/tilingshell" = {
    #   top-edge-maximize = true;
    #   show-indicator = false;
    # };
    # Make alt-tab behave like in windows.
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

  dev = {
    enable = true;
    environments = {
      c.enable = true;
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
    if command -v fzf-share >/dev/null; then
      source "$(fzf-share)/key-bindings.bash"
      source "$(fzf-share)/completion.bash"
    fi  
    '';
  };

  programs.kitty = {
    enable = true;
  };

  home.packages = with pkgs; [
    fzf # fuzzy search 
    wl-clipboard # clipboard
    proton-pass
  ];

  home.file = { };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
