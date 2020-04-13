{ config, pkgs, lib, ... }:

let

  cfg = config.services.xserver.desktopManager.nide;


in {

  options = with lib; {

    services.xserver.desktopManager.nide = {};

  };

  config = lib.mkIf cfg.enable {

    # Add DejaVu font and same fonts as Plasma
    fonts.fonts = with pkgs; [
      jetbrains-mono
      dejavu_fonts
      noto-fonts
      hack-font
    ];

    # In order to set the default font for Simple Terminal, one has to patch
    # this line: https://git.suckless.org/st/file/config.def.h.html#l8
    #
    # Or, alternatively, wrap st so that it is always called with -f flag. But
    # then one cannot call st with another font flag.. Wait, yes they can! The
    # last -f flag is used so one can override the previous options. Nice.

    # These are the same fonts as Plasma uses
    fonts.fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ]; #"Hack" "Noto Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };

    # There also is the (new) i3-dmenu-desktop which only displays applications
    # shipping a .desktop file. It is a wrapper around dmenu, so you need that
    # installed.
    services.xserver.desktopManager.nide.i3Config = ''
      font pango:JetBrains Mono 8
    '';

  };

}
