# NixOS configuration that can be imported in your own
# /etc/nixos/configuration.nix file. This makes a few helpful system-wide
# settings and installs NiDE dependencies system-wide.
#
# See README for more detailed instructions.

{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver.desktopManager.nide;
in {

  options = {
    services.xserver.desktopManager.nide = {
      enable = lib.mkEnableOption "Niche i3 Desktop Environment";
      installPackages = lib.mkEnableOption "NiDE system-wide packages";
    };
  };

  config = lib.mkIf cfg.enable {
    # Use none (i.e., xterm as the desktop manager)
    services.xserver.desktopManager.xterm.enable = true;

    # Set fonts
    fonts.packages = with pkgs; [
      noto-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fonts.fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono NF" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };

    # Keybindings for adjusting monitor brightness. Adjusting brightness with
    # actkbd+light is nice because it's independent of X and works in ttys.
    services.actkbd = {
      enable = true;
      bindings = let
        light = "${pkgs.light}/bin/light";
        step = "5";
      in [
        {
          keys = [ 224 ];
          events = [ "key" ];
          # Use minimum brightness 0.1 so the display won't go totally black.
          command = "${light} -N 0.1 && ${light} -U ${step}";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "${light} -A ${step}";
        }
      ];
    };

    # Enable users to modify brightness. NOTE: User must belong to video group!
    # (These modify udev rules, so if you just enabled this, probably best to
    # reboot.)
    programs.light.enable = true;
    hardware.acpilight.enable = true;

    # Installing the NiDE dependencies is optional as they can be installed also
    # by the user. See README for more information.
    environment.systemPackages = lib.optionals cfg.installPackages (
      (import ./packages.nix) { inherit pkgs; }
    );
  };

}
