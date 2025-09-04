<div align = center>

# Sam's Dotfiles **_NEBULIX_** WIP

![License](https://img.shields.io/github/license/Samtroulcode/dotfiles?style=flat-square)
![Last commit](https://img.shields.io/github/last-commit/Samtroulcode/dotfiles?style=flat-square)
![Repo size](https://img.shields.io/github/repo-size/Samtroulcode/dotfiles?style=flat-square)
![Issues](https://img.shields.io/github/issues/Samtroulcode/dotfiles?style=flat-square)
![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)
![Managed with Stow](https://img.shields.io/badge/managed%20with-gnu%20stow-informational?style=flat-square)

My personal Linux dotfiles

I use Arch btw.

| ![Nebulix1](./assets/Readme/nebulix1.png) | ![Nebulix2](./assets/Readme/nebulix2.png) |
| ----------------------------------------- | ----------------------------------------- |
| ![Nebulix3](./assets/Readme/nebulix3.png) | ![Nebulix4](./assets/Readme/nebulix4.png) |

[Showcase video](https://files.catbox.moe/kbrmnl.mp4)

</div>

## Note on this repository

I use this repo to sync and backup my dotfiles.

I use stow to manage my dotfiles, so each folder starting with "nebu-" is a package that you can stow in your home directory.

## Installation

> [!WARNING]
> You need to have `stow` installed on your system to manage these dotfiles. `stow` will create symlinks from your dotfiles repository to your `$HOME`, so you don’t overwrite files directly.
> You can install it with your package manager. For example, on Arch Linux, you can use:

```bash
sudo pacman -S stow
```

### Install dependencies and deploy configurations

1. Backup your current dotfiles

2. Clone this repository

```bash
git clone https://github.com/Samtroulcode/dotfiles.git && cd dotfiles
# or if you use ssh
git clone git@github.com:Samtroulcode/dotfiles.git && cd dotfiles
```

3. Install the packages you want to use then stow them

```bash
sudo pacman -S <package-name>
stow nebu-<package-name>
```

> [!NOTE]
> If you want to install **all dependencies** and deploy all configurations at once:

```bash
sudo pacman -S ghostty hyprland swww mpv mpd ncmpcpp neovim qutebrowser tmux starship swaync superfile waybar wlogout wofi zsh btop
stow nebu-*
```

### Uninstall

To uninstall a package, simply use `stow -D` followed by the package name:

```bash
stow -D nebu-<package-name>
```

## List of tools used

<div align = center>

| Tool                | Name/site                                                      | repository                                                     | config                                                | doc                                          |
| ------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------------------------- | -------------------------------------------- |
| wayland compositor  | [Hyprland](https://hypr.land/)                                 | [github](https://github.com/hyprwm/Hyprland)                   | [hypr](./nebu-hyprland/.config/hypr)                  | [section](#hyprland)                         |
| web browser         | [Qutebrowser](https://www.qutebrowser.org/)                    | [github](https://github.com/qutebrowser/qutebrowser)           | [qutebrowser](./nebu-qutebrowser/.config/qutebrowser) | [section](#web-browser-qutebrowser)          |
| terminal            | [Ghostty](https://ghostty.org/)                                | [github](https://github.com/ghostty-org/ghostty)               | [ghostty](./nebu-ghostty/.config/ghostty/)            | WIP                                          |
| shell               | [Oh my zsh](https://ohmyz.sh/)                                 | [github](https://github.com/ohmyzsh/ohmyzsh)                   | [zsh](./nebu-zsh/)                                    | WIP                                          |
| shell theming       | [Starship](https://starship.rs/)                               | [github](https://github.com/starship/starship)                 | [starship](.config/starship.toml)                     | WIP                                          |
| file explorer       | [Superfile](https://superfile.netlify.app/)                    | [github](https://github.com/yorukot/superfile)                 | [spf](./nebu-spf/.config/superfile)                   | WIP                                          |
| status bar          | [Waybar](https://github.com/Alexays/Waybar)                    | [github](https://github.com/Alexays/Waybar)                    | [waybar](./nebu-waybar/.config/waybar)                | WIP                                          |
| menu                | [Wofi](https://hg.sr.ht/~scoopta/wofi)                         | [sourcehut](https://hg.sr.ht/~scoopta/wofi)                    | [wofi](./nebu-wofi/.config/wofi)                      | WIP                                          |
| power menu          | [Wlogout](https://github.com/ArtsyMacaw/wlogout)               | [github](https://github.com/ArtsyMacaw/wlogout)                | [wlogout](./nebu-wlogout/.config/wlogout)             | WIP                                          |
| notification daemon | [Swaync](https://github.com/ErikReider/SwayNotificationCenter) | [github](https://github.com/ErikReider/SwayNotificationCenter) | [swaync](./nebu-swaync/.config/swaync)                | WIP                                          |
| wallpaper backend   | [Swww](https://github.com/LGFae/swww)                          | [github](https://github.com/LGFae/swww)                        | [swww](./nebu-swww/.config/swww)                      | WIP                                          |
| color generator     | [Wallust](https://explosion-mental.codeberg.page/wallust/)     | [codeberg](https://codeberg.org/explosion-mental/wallust)      | [wallust](./nebu-wallust/.config/wallust)             | WIP                                          |
| music daemon        | [Mpd](https://www.musicpd.org/)                                | [github](https://github.com/MusicPlayerDaemon/MPD)             | [mpd](./nebu-mpd/.config/mpd/)                        | WIP                                          |
| music player        | [Rmpc](https://mierak.github.io/rmpc/)                         | [github](https://github.com/mierak/rmpc)                       | [rmpc](./nebu-music/.config/rmpc)                     | WIP                                          |
| video player        | [Mpv](https://mpv.io/)                                         | [github](https://github.com/mpv-player/mpv)                    | [mpv](./nebu-mpv/.config/mpv)                         | WIP                                          |
| multiplexer         | [Tmux](https://github.com/tmux/tmux/wiki)                      | [github](https://github.com/tmux/tmux)                         | [tmux](./nebu-tmux/)                                  | WIP                                          |
| Text editor/IDE     | [Nvim](https://neovim.io/)                                     | [github](https://github.com/neovim/neovim)                     | [nvim](./nebu-nvim/.config/nvim)                      | [readme](./nebu-nvim/.config/nvim/README.md) |

</div>

### Window manager **_HYPRLAND_**

![Hyprland1](https://raw.githubusercontent.com/hyprwm/Hyprland/main/assets/header.svg)

Hyprland is a modern, dynamic Wayland compositor featuring both tiling and floating window management, with smooth animations and deep customization. It replaces both the window manager and the compositor, making it ideal for advanced users seeking a minimal and responsive Wayland setup.

I separated my configuration into several files :

- [hyprland](./nebu-hyprland/.config/hypr/hyprland.conf) : contains monitor informations, some general settings, and other configuration files imports
- [env](./nebu-hyprland/.config/hypr/config/env.conf) : contains environment variables such as nvidia required variables, hyprcursor theme or keyboard layout
- [start](./nebu-hyprland/.config/hypr/config/start.conf) : contains exec-once entries such as notification daemon or launch scripts
- [var](./nebu-hyprland/.config/hypr/config/var.conf) : contains hyprland variables such as my terminal or file manager.
- [key](./nebu-hyprland/.config/hypr/config/key.conf) : my keybindings
- [colors](./nebu-hyprland/.config/hypr/config/colors.conf) : my color configuration linked with wallust, since is dynamically generated when i change my wallpapers, i didn't push it to my git. (see [wallust] section)
- [window](./nebu-hyprland/.config/hypr/config/window.conf) : some window rules for apps (like spf floating instead of tiling)
- [theme](./nebu-hyprland/.config/hypr/config/theme.conf) : general theming such as blur or inactive timeout for the cursor.
- [anim](./nebu-hyprland/.config/hypr/config/anim) : it's a folder containing some animations files, i choose one of those in my import list in [hyprland.conf](./nebu-hyprland/.config/hypr/hyprland.conf)
- [plugin](./nebu-hyprland/.config/hypr/config/plug.conf) : contains list of hyprland plugin. Actually, i only use one plugin, [HyprExpo](https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo).

#### Config tips

> [!WARNING]
> To add hyprland plugins, you must have hyprland-git installed cause you need the headers exposed by hyprpm to add some plugins.

<div align = center>

### Web Browser **_QUTEBROWSER_**

![Qutebrowser1](./assets/Readme/qutebrowser1.png)

</div>

Qutebrowser is a fancy light browser, extremely customizable and keyboard centered with use of VIM motions. For configuration, it use python scripts, which allows deep customization.

original repo : [Qutebrowser](https://github.com/qutebrowser/qutebrowser)

my configs files : [qutebrowser configs](./nebu-qutebrowser/.config/qutebrowser)

i separated my configuration into several files. The principal configuration file with privacy settings, searchengines and global configuration is [here](./nebu-qutebrowser/.config/qutebrowser/config.py) and for my style customization i created a [separated python file](./nebu-qutebrowser/.config/qutebrowser/themes/nebulix.py) that i source in my global customization file :

```python
config.source('themes/nebulix.py')
```

#### Config tips

to watch youtubes videos without ads, i know 3 methods actually. You can simply watch the youtube video in mpv by binding a shortcut like that :

```python
config.bind('<Ctrl+/>', 'hint links spawn mpv {hint-url}')
```

you need yt-dlp and mpv to do this

```bash
sudo pacman -S yt-dlp mpv
```

It will open an MPV player with the YouTube video without the ads, first i hit my shortcut, then i select the video, here is the workflow :

| Step 1                            | Step 2                            |
| --------------------------------- | --------------------------------- |
| ![mpv2](./assets/Readme/mpv1.png) | ![mpv2](./assets/Readme/mpv2.png) |

The second method is similar to the first but it uses a custom script which allows you to have a single instances of MPV and to add videos in queues, a bit like a playlist.

Script link : [umpv](https://github.com/mpv-player/mpv/blob/master/TOOLS/umpv)

you need to add this script to your $PATH then you simply do this :

```bash
config.bind('<Ctrl+/>', 'hint links spawn umpv --enqueue {hint-url}')
```

The third method use a Dreasemonkey script, but i not cover this solution here, you at least know that it exists.

## Management

I'm using [gnu stow](https://www.gnu.org/software/stow/) to manage these dotfiles
