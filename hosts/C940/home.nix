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
