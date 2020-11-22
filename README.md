# NiDE - Niche i3 Desktop Environment

*In Finnish, "nide" means a book or a volume and refers to the binding that ties
the pages together. In English, "nide" means a group of pheasants. Similarly,
NiDE ties a collection of amazing software packages together to form a desktop
environment.*

## Overview

NiDE is a light keyboard-driven Linux desktop environment installed in the home
directory. NiDE is constructed from a collection of amazing software packages to
provide a full desktop-environment experience similar to GNOME, KDE, XFCE and
many other desktop environments. NiDE aims to provide a simplistic and light but
powerful desktop environment with good support for keyboard interface and tiling
windows. It can be easily installed and configured in the home directory without
system administrator. NiDE is installed in a separate directory so it won't mess
up your other desktop environments and existing configurations.

**NOTE: Previously NiDE was called "NixOS i3 Desktop Environment" and it was a
configuration just for NixOS. That is deprecated but still available in
`nixos-nide` branch. Currently, NiDE works on any Linux operating system and it
can be installed in the user home directory without root. But there is still
good support for NixOS similar to what it used to be.**

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

- [i3](https://i3wm.org/) for window management
- [Polybar](https://polybar.github.io/) as the status bar
- [Rofi](https://github.com/davatorium/rofi) as a generic menu and launcher
- [Pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) for sound
  management
- [NetworkManager](https://wiki.gnome.org/Projects/NetworkManager) for network
  connection management
- [pass](https://www.passwordstore.org/) for storing passwords and passphrases
- [pass-secret-service](https://github.com/mdellweg/pass_secret_service/) for
  integrating pass with the standard secret service D-Bus interface.
- [Dunst](https://dunst-project.org/) for showing desktop notifications
- [Dex](https://github.com/jceb/dex) for autostarting desktop applications when
  logging in
- [Alacritty](https://github.com/alacritty/alacritty) as the default terminal
- [Simple X Image Viewer (sxiv)](https://github.com/muennich/sxiv) as the
  default image viewer
- [Luakit](https://luakit.github.io/) as the default browser with vim-like
  keybindings and minimal visual garbage
- [udiskie](https://github.com/coldfix/udiskie) for automounting removable
  media
- [kbdd](https://github.com/qnikst/kbdd) for managing keyboard layouts per
  window
- [light](https://haikarainen.github.io/light/) for controlling the screen
  backlight
- [actkbd](https://github.com/thkala/actkbd) for keybindings that work also in
  virtual terminals
- [XSecureLock](https://github.com/google/xsecurelock) as a lock screen
- [autorandr](https://github.com/phillipberndt/autorandr) for managing monitor
  configurations automatically
- .. and many other amazing open-source software packages

Some small possibly interesting details:

- Keyboard layouts are window-specific.
- Computer locking with `Ctrl+Alt+L` works also in virtual terminals if the user
  has logged in.
- Brightness and volume control keybindings work also in virtual terminals.

## Installation

Copy this repository under `~/.nide`. You can use `git` to clone:

```
git clone https://github.com/jluttine/NiDE ~/.nide
```

Alternatively, you can download a tarball of your choice

- Releases: https://github.com/jluttine/NiDE/releases
- Latest development snapshot: https://github.com/jluttine/NiDE/archive/master.zip

Unpack the tarball to `~/.nide`.

Now you just need to run `~/.nide/bin/nide` as your X session startup script.
For instance, use it as your `~/.xsession` script and at log-in time choose a
session that will run that script (at least in NixOS `xterm` session does that):

```
ln -s ~/.nide/bin/nide ~/.xsession
```

Other (and better) ideas of how to launch NiDE are welcome!

The packages NiDE uses need to be installed for NiDE to work. How to install
those packages depends on the Linux distro, see below for some examples.

### Nix/NixOS

There are two ways to install the dependencies on NixOS as described below:

#### Home-directory installation of dependencies

In the root of NiDE repository, run:

```
nix-build
```

Now, there should be `~/.nide/result` directory (or, more precisely, a symlink
to a directory) that contains the dependencies. When NiDE is launched, it'll add
those paths to relevant environment variables, so they are available (only) when
running NiDE without affecting your entire system or other desktop environments.
This also makes it possible to update the environment while running it without
needing to restart NiDE because only the target of the symlink changes.

Note that with this approach, you need to take care of updating the packages
manually (i.e., running `nix-build`) because they won't be updated automatically
when the system is updated. This can have its pros and cons but it's something
to be aware of.

#### System-wide installation of dependencies

In your `configuration.nix`, import NiDE and enable it:

```
{ pkgs, ...}:
let
  nide = builtins.fetchTarball {
    url = "https://github.com/jluttine/NiDE/archive/master.tar.gz";
    sha256 = null;
  };
in {
  imports = [
    ...
    "${nide}/nix/configuration.nix"
  ];
}
```

It's recommended to pin the tarball to a specific commit or tag and then set
`sha256`. However, that isn't done here because it's difficult to maintain in
this README file. Of course, you can also use your local check-out of the
repository and import from that path instead of GitHub.

Alternatively, you can install only the packages but not set the other
configuration options:

```
{ pkgs, ...}:
let
  nide = builtins.fetchTarball {
    url = "https://github.com/jluttine/NiDE/archive/master.tar.gz";
    sha256 = null;
  };
in {
  config = {
    ...
    environment.systemPackages = [
      ...
    ] ++ ((import "${nide}/nix/packages.nix") { inherit pkgs; });
  };
}
```

### Ubuntu and others

TODO

## Usage

The user is assumed to be familiar with basic i3 usage. Here are some important
keybindings that are configured in NiDE:

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

- Use Dhall to provide a high-level configuration syntax for NiDE and then
  compile these to the actual dotfiles that the various software package read.
  Similarly as nix is used to configure NixOS.
- Make keybindings configurable. Almost everything is now hard-coded.
- Configure solarized dark and light color themes for the desktop environment.
- Allow other keyboard layouts than `fi` and `us`.
- Find a decent graphical email client.
- Add X11 lock screen and dimmer.
- Define XDG default applications.
- Define user XDG directories.
- Run/source correct dotfiles from the user home directory (e.g., `.profile`).
- Add icons
- Customize rofi-file-browser appearance after
  https://github.com/marvinkreis/rofi-file-browser-extended/issues/24

## Contributions

Contributions are most welcome. Just open an issue or a pull request. Feel free
to suggest better default applications or configurations.

## Copyright

*The following copyright information holds for the files in this git repository.
NixOS and all the packages that are used by NiDE have their own licenses.*

Copyright (C) 2019-2020 Jaakko Luttinen

NiDE is licensed under the MIT License.
