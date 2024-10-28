{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "24.05"; 
  home.username = "skarv";
  home.homeDirectory = "/home/skarv";

  imports = [
    inputs.nvchad4nix.homeManagerModule
    inputs.ags.homeManagerModules.default
    inputs.matugen.nixosModules.default
    ../../modules/nvchad
    # ../../modules/gnome
    #../../modules/hyprland
    #../../modules/waybar/default.nix
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
    if command -v fzf-share >/dev/null; then
      source "$(fzf-share)/key-bindings.bash"
      source "$(fzf-share)/completion.bash"
    fi  
    '';
  };


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

  programs.kitty = {
    enable = true;
   # font = {
   #     name = "JetBrainsMono Nerd Font";
   #     size = 11;
   #   };
   #   theme = "Catppuccin-Macchiato";
  };

  home.packages = with pkgs; [
    fzf # fuzzy search 
    wl-clipboard # clipboard
    proton-pass
    # coding
    oprofile
    gdb
    valgrind
    gnumake
  ];

  home.file = { };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
