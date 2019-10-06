# NiDE - NixOS i3 Desktop Environment

*In Finnish, "nide" means a book or a volume and refers to the binding that ties
the pages together. In English, "nide" means a group of pheasants. Similarly,
NiDE ties a collection of amazing software packages together to form a desktop
environment.*

## Overview

NiDE is a desktop environment constructed with [NixOS](https://nixos.org/). It
uses i3 as the window manager and many other software packages to provide a full
desktop-environment experience similar to GNOME, KDE, XFCE and many other
desktop environments. NiDE aims to provide a simplistic and light but powerful
desktop environment with good support for keyboard interface and tiling windows.
It can be configured via NixOS options but the default configuration and
packages should provide a good and complete experience.

**NOTE: NiDE is currently very much work in progress and it's mainly configured
for my personal needs at the moment. There are still many things that are
missing or aren't working properly. Also, no effort has yet been put to the
visual appearance.**

NiDE is constructed by putting together numerous amazing open-source software
packages. The point of NiDE is to select these great packages and put them
together with a decent default configuration. When selecting the software
packages, the following guidelines are taken into account if there are multiple
options. The software package should preferably:

- not be bloated nor overly complex but still do well what it's supposed to do
- have good keyboard user interface
- be configurable with text files
- use standards for things it does
- work well with a tiling window manager
- not fill the window with graphical garbage (e.g., large menu/icon bars) but
  rather try to maximize the space for the actual content

The following non-exhaustive list mentions some of the awesome software packages
used to form NiDE:

- [i3](https://i3wm.org/) for window management.
- [Polybar](https://polybar.github.io/) as the status bar.
- [Rofi](https://github.com/davatorium/rofi) as a generic menu and launcher.
- [Pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) for sound
  management.
- [NetworkManager](https://wiki.gnome.org/Projects/NetworkManager) for network
  connection management.
- [GNOME Keyring](https://wiki.gnome.org/Projects/GnomeKeyring/) for storing
  passwords and passphrases.
- [Simple Terminal (st)](https://st.suckless.org/) as the default terminal.
- [Simple X Image Viewer (sxiv)](https://github.com/muennich/sxiv) as the
  default image viewer.
- [Luakit](https://luakit.github.io/) as the default browser with vim-like
  keybindings and minimal visual garbage.
- [udiskie](https://github.com/coldfix/udiskie) for automounting removable
  media.
- [kbdd](https://github.com/qnikst/kbdd) for managing keyboard layouts per
  window.
- [light](https://haikarainen.github.io/light/) for controlling the screen
  backlight.
- [actkbd](https://github.com/thkala/actkbd) for keybindings that work also in
  virtual terminals.
- [physlock](https://github.com/muennich/physlock) as a lock screen that works
  also in virtual terminals.
- [autorandr](https://github.com/phillipberndt/autorandr) for managing monitor
  configurations automatically.
- .. and many other amazing open-source software packages.

Some small possibly interesting details:

- Keyboard layouts are window-specific.
- Computer locking with `Ctrl+Alt+L` works also in virtual terminals if the user
  has logged in.
- Brightness and volume control keybindings work also in virtual terminals.

## Installation

In your `configuration.nix`, import NiDE and enable it:

```
{ pkgs, ...}:
let
  nide = pkgs.fetchFromGitHub {
    owner = "jluttine";
    repo = "nide";
    rev = "some tag or commit";
    sha256 = "its sha256 hash";
  };
in {
  imports = [
    ...
    nide
  ];

  config = {
    ...
    services.xserver.desktopManager.nide.enable = true;
    ...
  };
}
```

Just choose the revision (tag or commit) you want and remember to put the
correct hash.

## Usage

The user is assumed to using [NixOS](https://nixos.org/) and be familiar with
basic i3 usage. Here are some important keybindings that are configured in NiDE:

- `Super` is the i3 modifier key.
- `Super+Space` opens the Rofi application launcher.
- `Super+Esc` closes the current window.
- `Super+Enter` opens a terminal.
- `Ctrl+Alt+L` locks the computer.
- `Ctrl+Alt+Del` opens a system power menu.
- `Super+Shift+Space` switches the keyboard layout.
- `Super+h/j/k/l` move focus to another window.
- `Super+Shift+h/j/k/l` move the focused window.
- `Super+w/e/s` switch to tabbed/split/stacked mode.
- `Super+1/2/3/...` move to workspace 1/2/3/...
- `Super+Shift+1/2/3/...` move window to workspace 1/2/3/...

Also, `Caps Lock` key is used as `Esc`.

## TODO

- Make keybindings configurable. Almost everything is now hard-coded.
- Configure solarized dark and light color themes for the desktop environment.
- Allow other keyboard layouts than `fi` and `us`.
- Find a decent graphical email client.
- Add X11 lock screen and dimmer.
- Define XDG default applications.

## Contributions

Contributions are most welcome. Just open an issue or a pull request. Feel free
to suggest better default applications or configurations.

## Copyright

*The following copyright information holds for the files in this git repository.
NixOS and all the packages that are used by NiDE have their own licenses.*

Copyright (C) 2019 Jaakko Luttinen

NiDE is licensed under the MIT License.

## About the name
