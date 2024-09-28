{ config, pkgs, inputs, ... }:

{
  home.username = "skarv";
  home.homeDirectory = "/home/skarv";

  imports = [
    inputs.nvchad4nix.homeManagerModule
    ../../modules/waybar/default.nix
  ];

  programs.bash.enable = true;


  wayland.windowManager.hyprland = {
  enable = true;

  settings = {
    monitor = ",preferred,auto,1.2";

    "$terminal" = "kitty";
    "$menu" = "rofi -show drun -terminal foot";
    "$mod" = "SUPER";

    exec-once = [
     "waybar" 
     "mako"
     "rofi-wayland"
    ];

    env = [
      "HYPRCURSOR_SIZE,24"
      "XCURSOR_SIZE,24"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

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
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";

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
        scroll_factor = 0.5;
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

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];

    windowrulev2 = "suppressevent maximize, class:.*";

    # Xwayland can't handle scaling properly. Small is better than blurry.
    xwayland = {
      force_zero_scaling = true;
    };
  };
  };

  programs.nvchad = {
    enable = true;
    extraConfig = 
      ''
      -- fix borders
      local modified = false
      vim.api.nvim_create_autocmd({'UIEnter', 'ColorScheme'}, {
        callback = function()
          local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
          if normal.bg then#
              io.write(string.format('\027]11;#%06x\027\\', normal.bg))
              modified = true
          end
        end,
      })
      vim.api.nvim_create_autocmd('UILeave', {
        callback = function()
          if modified then
              io.write('\027]111\027\\')
          end
        end,
      })
      '';
  };

  programs.git = {
    enable = true;
    extraConfig = {
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

  programs.kitty = {
    enable = true;
    font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
      theme = "Catppuccin-Macchiato";
  };

  home.stateVersion = "24.05"; 

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  
  home.file.".config/hypr/colors".text = ''
    $background = rgba(1d192bee)
    $foreground = rgba(c3dde7ee)

    $color0 = rgba(1d192bee)
    $color1 = rgba(465EA7ee)
    $color2 = rgba(5A89B6ee)
    $color3 = rgba(6296CAee)
    $color4 = rgba(73B3D4ee)
    $color5 = rgba(7BC7DDee)
    $color6 = rgba(9CB4E3ee)
    $color7 = rgba(c3dde7ee)
    $color8 = rgba(889aa1ee)
    $color9 = rgba(465EA7ee)
    $color10 = rgba(5A89B6ee)
    $color11 = rgba(6296CAee)
    $color12 = rgba(73B3D4ee)
    $color13 = rgba(7BC7DDee)
    $color14 = rgba(9CB4E3ee)
    $color15 = rgba(c3dde7ee)
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/skarv/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
