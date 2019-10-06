{ config, pkgs, lib, ... }:

let

  cfg = config.services.xserver.desktopManager.nide;

in {

  options = with lib; { };

  config = lib.mkIf cfg.enable {

    # Notification servers. Some possible light-weight choices could be:
    # - Dunst
    # - Deadd Notification Center
    # - Statnot
    # - Twmn

    # Without this, D-Bus didn't seem to work.. Not sure though.
    services.xserver.startDbusSession = true;
    services.xserver.updateDbusEnvironment = true;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.dunst ];

    # This is the default, but setting true just broke all dbus things..
    services.dbus.socketActivated = false;

    environment.systemPackages = with pkgs; [
      libnotify

      # Dunst contains a DBUS service file for org.freedesktop.Notifications, so
      # just installing it should be enough to get the notifications. Not sure
      # how one could have different notification DBUS daemons in different
      # desktop environments.
      dunst
    ];

  };

}
