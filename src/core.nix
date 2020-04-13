{ config, pkgs, lib, ... }:

let

  cfg = config.services.xserver.desktopManager.nide;


in {

  options = with lib; {

    services.xserver.desktopManager.nide = {};

  };

  config = lib.mkIf cfg.enable {

    # There also is the (new) i3-dmenu-desktop which only displays applications
    # shipping a .desktop file. It is a wrapper around dmenu, so you need that
    # installed.
    services.xserver.desktopManager.nide.i3Config = ''
      set $mod Mod4

      bindsym $mod+space exec ${pkgs.rofi}/bin/rofi -show drun -modi drun#run -matching fuzzy -show-icons -sidebar-mode

      floating_modifier $mod

      hide_edge_borders smart

      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart; exec ${pkgs.polybar}/bin/polybar-msg cmd restart
    '';
      #default_border none

    # Other core apps for making a complete desktop environment experience.
    environment.systemPackages = with pkgs; [
      rofi
    ];

  };

}
