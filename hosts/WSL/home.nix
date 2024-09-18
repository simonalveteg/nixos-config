{ config, pkgs, inputs, ... }:

{
  home.username = "skarv";
  home.homeDirectory = "/home/skarv";

  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    extraConfig = 
      ''
      -- fix borders
      local modified = false
      vim.api.nvim_create_autocmd({'UIEnter', 'ColorScheme'}, {
        callback = function()
          local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
          if normal.bg then
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

  programs.bash.enable = true;

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

  home.stateVersion = "24.05"; 

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
