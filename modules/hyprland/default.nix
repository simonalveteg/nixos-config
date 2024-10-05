{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  
  programs.ags = {
    enable = true;
    #configDir = null;
    configDir = ../ags;
    extraPackages = with pkgs; [
      # Battery
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.apps
      inputs.ags.packages.${pkgs.system}.hyprland
      
    ];
  };

  #home.file."gtk-4.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css";

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = ",preferred,auto,1.2";

      "$terminal" = "kitty";
      "$menu" = "rofi -show drun -terminal foot";
      "$mod" = "SUPER";

      exec-once = [
        "ags"
        "hyprctl setcursor Qogir 24"
        "mako"
        "rofi-wayland"
        "hyprpaper"
        "hypridle"
      ];

      env = [
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 8;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base05})";
        "col.inactive_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base00})";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 1;
        #"col.shadow" = "rgba(1a1a1aee)";

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # https://easings.net/#easeOutQuint
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      # Disable all animations, except for workspace switching.
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "se";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        # Start repeating a key after holding it down for these many milliseconds.
        repeat_delay = 200;

        # While repeating a key, fire a new event every these many milliseconds.
        repeat_rate = 30;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.2;
          clickfinger_behavior = true; # enable right click on two finger press
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = true;
      };

      # ********** Key Bindings **********
      # See https://wiki.hyprland.org/Configuring/Binds/ for more.

      bind = [
        "$mod, Q, exec, $terminal" 
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, L, exec, hyprlock"
        "$mod, E, exec, $fileManager"
        "$mod, V, toggleFloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        # move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        # AGS widgets
        ", XF86PowerOff, exec, ags -t powermenu"
        "$mod, R, exec, ags -t launcher"
        "$mod, Tab, exec, ags -t overview"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      bindm = [
        # Move/resize windows
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ",switch:Lid Switch, exec, suspend" # Lock when closing Lid
      ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "noborder, onworkspace:w[t1]"
      ];
     

      # Xwayland can't handle scaling properly. Small is better than blurry.
      xwayland = {
        force_zero_scaling = true;
      };
    };
  };
}
