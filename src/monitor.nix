{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver.desktopManager.nide;
in {

  options = with lib; {
    services.xserver.desktopManager.nide.monitorLayout = {
      automation = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.monitorLayout.automation.enable) {

    services.autorandr.enable = true;

    environment.systemPackages = with pkgs; [
      autorandr
    ];

  };

}
