{ config, pkgs, ...}:

{
    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                hide_cursor = false;
                no_fade_in = true;
                grace = 0;
                disable_loading_bar = true;
            };

            background = [
                {
                    path = "~/nixos/wallpapers/42617.jpg";
                    blur_passes = 1;
                    contrast = 1;
                    brightness = 0.5;
                    vibrancy = 0.2;
                    vibrancy_darkness = 0.2;

                    new_optimizations = true;
                    ignore_opacity = false;
                }
            ];

            input-field = [
                {
                    size = "250, 60";
                    outline_thickness = 2;
                    dots_size = 0.2;
                    dots_spacing = 0.35;
                    dots_center = true;

                    fade_on_empty = false;

                    inner_color = "rgba(0, 0, 0, 0.2)";
                    outer_color = "rgba(0, 0, 0, 0)";
                    font_color = "rgba(255, 255, 255, 1)";
                    capslock_color = "rgba(0, 0, 170, 0.5)";

                    placeholder_text = ''<i><span foreground="##cdd674">Input Password</span></i>'';
                    position = "0, -200";
                    halign = "center";
                    valign = "center";
                }
            ];

            label = [
                {
                    text = ''cmd[update:1000] echo "<span>$(date '+%A,%d %B')</span>"'';
                    color = "rgba(242, 243, 244, 0.75)";
                    
                    font_size = 32;
                    font_family = "JetBrains Mono";

                    position = "0, 300";
                    halign = "center";
                    valign = "center";
                }
                {
                    text = ''cmd[update:1000] echo "<span>$(date '+%I:%M %p ')</span>"'';
                    color = "rgba(242, 243, 244, 0.75)";
                    font_size = 95;
                    font_family = "JetBrains Mono Extrabold";

                    position = "0, 200";
                    halign = "center";
                    valign = "center";
                }
            ];
        };
    };
}
