{ config, ... }: {

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [ 
        "~/nixos/wallpapers/42625.jpg" 
      ];
      wallpaper = [ ", ~/nixos/wallpapers/42625.jpg" ];
    };
  };

}
