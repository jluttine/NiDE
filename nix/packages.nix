{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let

  polybar-kdeconnect = let
    deps = lib.makeBinPath [ pkgs.qt5.qttools pkgs.coreutils pkgs.gawk pkgs.rofi
                             pkgs.zenity plasma5Packages.kdeconnect-kde ];
  in pkgs.stdenv.mkDerivation rec {
    pname = "polybar-kdeconnect";
    version = "unstable-2019-05-28";
    src = pkgs.fetchFromGitHub {
      owner = "HackeSta";
      repo = pname;
      rev = "f640a070654f4be0ea949ffd07c8bf1fcf1b6b50";
      sha256 = "0sidj654gys9fdp5v6cmr2s9lmxaps2dacq46wcy666ykgdjyx29";
    };
    buildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/libexec
      mv polybar-kdeconnect.sh $out/libexec/
      wrapProgram $out/libexec/polybar-kdeconnect.sh --prefix PATH : ${deps};
    '';
    doCheck = false;
  };

  rofi-script-to-dmenu = stdenv.mkDerivation rec {
    pname = "rofi-script-to-dmenu";
    version = "1.1.0";
    src = fetchFromGitHub {
      owner = "jluttine";
      repo = pname;
      rev = version;
      sha256 = "0fgyc5kaw1784lqdfj1w995imh2c5x7fvvmh4ll120963zc78pg6";
    };
    buildPhase = "";
    installPhase = ''
      install -Dm755 rofi-script-to-dmenu $out/bin/rofi-script-to-dmenu
    '';
  };

  rofi-power-menu = stdenv.mkDerivation rec {
    pname = "rofi-power-menu";
    version = "3.1.0";
    src = fetchFromGitHub {
      owner = "jluttine";
      repo = pname;
      rev = version;
      sha256 = "sha256-VPCfmCTr6ADNT7MW4jiqLI/lvTjlAu1QrCAugiD0toU=";
    };
    buildPhase = "";
    installPhase = ''
      install -Dm755 rofi-power-menu $out/bin/rofi-power-menu
      install -Dm755 dmenu-power-menu $out/bin/dmenu-power-menu
    '';
  };

  kill-window = let
    xprop = "${xorg.xprop}/bin/xprop";
    awk = "${gawk}/bin/awk";
  in pkgs.writeScriptBin "kill-window" ''
    #!/bin/sh
    set -x
    window_ID=$(${xprop} -root | ${awk} '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    window_PID=$(${xprop} -id $window_ID | ${awk} '/_NET_WM_PID\(CARDINAL\)/{print $NF}')
    kill -$1 $window_PID
  '';

in [
  i3
  (rofi.override {
    plugins = [ rofi-file-browser ];
  })
  (polybar.override {
    i3Support = true;
    pulseSupport = true;
    nlSupport = false;
    iwSupport = true;
    wirelesstools = wirelesstools;
    #githubSupport = true;
    #mpdSupport = true;
  })
  (kbdd.overrideAttrs (oldAttrs: {
    # KBDD doesn't work if it is started without a window in focus. It'll
    # not detect EWMH support and fallback to some generic mode that doesn't
    # remember the layout of the windows.. This patch just forces it to
    # believe there is always EWMH support whether it can detect it or not.
    # A better solution could be that KBDD would have a global state
    # keyboard layout which is used when no window is focused.
    #
    # TODO: Add global (no window in focus) keyboard layout state.
    #patches = [ ./kbdd.patch ];
    #
    # This was possibly fixed by https://github.com/qnikst/kbdd/pull/53
  }))
  dunst
  libnotify
  dex
  alacritty
  xidlehook # monitors idle time and sends screenlock requests
  xss-lock # listens for screenlock requests
  xsecurelock # screenlock
  picom
  hsetroot  # picom-supported replacement for xsetroot
  autorandr
  pass-secret-service
  sxiv
  mupdf
  trash-cli
  luakit
  arandr
  kill-window
  udiskie
  networkmanagerapplet

  polybar-kdeconnect

  rofi-script-to-dmenu
  rofi-power-menu

  gnupg
  pinentry-qt

  # Some extras
  zsh
  fzf
]
