{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
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
    version = "3.0.1";
    src = fetchFromGitHub {
      owner = "jluttine";
      repo = pname;
      rev = version;
      sha256 = "1kab1wabm5h73rj5p3114frjb7f1iqli89kfddrhp8z0n8348jw9";
    };
    buildPhase = "";
    installPhase = ''
      install -Dm755 rofi-power-menu $out/bin/rofi-power-menu
      install -Dm755 dmenu-power-menu $out/bin/dmenu-power-menu
    '';
  };

  kill-window = let
    xprop = "${xlibs.xprop}/bin/xprop";
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
    patches = [ ./kbdd.patch ];
  }))
  dunst
  libnotify
  dex
  alacritty
  xsecurelock
  xidlehook
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

  rofi-script-to-dmenu
  rofi-power-menu

  gnupg
  pinentry-qt

  # Some extras
  zsh
  fzf
]
