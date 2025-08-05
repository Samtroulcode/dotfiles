<div align = center>

# Sam's Dotfiles ***NEBULIX*** WIP

My personal Linux dotfiles

I use Arch btw.

| ![Nebulix1](wallpapers/nebulix-watch1.png) | ![Nebulix2](wallpapers/nebulix-watch2.png) |
| ---- | ---- |
| ![Nebulix3](wallpapers/nebulix-bar1.png) | ![Nebulix4](wallpapers/nebulix-bar2.png) |
| ![Nebulix3](wallpapers/nebulix-wave1.png) | ![Nebulix4](wallpapers/nebulix-wave2.png) |
| ![Nebulix3](wallpapers/nebulix-city1.png) | ![Nebulix4](wallpapers/nebulix-city2.png) |

[Showcase video](https://files.catbox.moe/v6n30o.mp4)

## Note on this repository

</div>

I use this repo to sync and backup my dotfiles.

The root of this repo is an equivalent to my $HOME directory

  > [!WARNING]
  > THIS IS NOT A PLUG AND PLAY DOTFILES ! There's no install scripts or step by step guide to install my files, you should know what you do if you want to use it. I only explain how my files are organized, and some tips with some tools. The comments in my files are mainly **IN FRENCH**

<div align = center>

## List of tools used

| Tool | Name/site | repository | config | doc |
| ---- | ---- | ---- | ---- | ---- |
| wayland compositer | [Hyprland](https://hypr.land/) | [github](https://github.com/hyprwm/Hyprland) | [hypr](.config/hypr) | [section](#hyprland) |
| web browser | [Qutebrowser](https://www.qutebrowser.org/) | [github](https://github.com/qutebrowser/qutebrowser) | [qutebrowser](.config/qutebrowser) | [section](#web-browser-qutebrowser) |
| terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) | [github](https://github.com/kovidgoyal/kitty) | [kitty](.config/kitty) | WIP |
| shell | [Oh my zsh](https://ohmyz.sh/) | [github](https://github.com/ohmyzsh/ohmyzsh) | [zsh](.config/zsh)/[zshrc](.zshrc) | WIP |
| shell theming | [Starship](https://starship.rs/) | [github](https://github.com/starship/starship) | [starship](.config/starship.toml) | WIP |
| file explorer | [Superfile](https://superfile.netlify.app/) | [github](https://github.com/yorukot/superfile) | [spf](.config/superfile) | WIP |
| status bar | [Waybar](https://github.com/Alexays/Waybar) | [github](https://github.com/Alexays/Waybar) | [waybar](.config/waybar) | WIP |
| menu | [Wofi](https://hg.sr.ht/~scoopta/wofi) | [sourcehut](https://hg.sr.ht/~scoopta/wofi) | [wofi](.config/wofi) | WIP |
| power menu | [Wlogout](https://github.com/ArtsyMacaw/wlogout) | [github](https://github.com/ArtsyMacaw/wlogout) | [wlogout](.config/wlogout) | WIP |
| notification daemon | [Swaync](https://github.com/ErikReider/SwayNotificationCenter) | [github](https://github.com/ErikReider/SwayNotificationCenter) | [swaync](.config/swaync) | WIP |
| wallpaper backend | [Swww](https://github.com/LGFae/swww) | [github](https://github.com/LGFae/swww) | [swww](.config/swww) | WIP |
| color generator | [Wallust](https://explosion-mental.codeberg.page/wallust/) | [codeberg](https://codeberg.org/explosion-mental/wallust) | [wallust](.config/wallust) | WIP |
| music daemon | [Mpd](https://www.musicpd.org/) | [github](https://github.com/MusicPlayerDaemon/MPD) | [mpd](.config/mpd) | WIP |
| music player | [Rmpc](https://mierak.github.io/rmpc/) | [github](https://github.com/mierak/rmpc) | [ncmpcpp](.config/rmpc) | WIP |
| Text editor/IDE | [Nvim](https://neovim.io/) | [github](https://github.com/neovim/neovim) | [nvim](.config/nvim) | WIP |

### Window manager *****HYPRLAND*****

![Hyprland1](https://raw.githubusercontent.com/hyprwm/Hyprland/main/assets/header.svg)

</div>

Hyprland is a modern, dynamic Wayland compositor featuring both tiling and floating window management, with smooth animations and deep customization. It replaces both the window manager and the compositor, making it ideal for advanced users seeking a minimal and responsive Wayland setup.

I separated my configuration into several files :

- [hyprland](.config/hypr/hyprland.conf) : contains monitor informations, some general settings, and other configuration files imports
- [env](.config/hypr/config/env.conf) : contains environment variables such as nvidia required variables, hyprcursor theme or keyboard layout
- [start](.config/hypr/config/start.conf) : contains exec-once entries such as notification daemon or launch scripts
- [var](.config/hypr/config/var.conf) : contains hyprland variables such as my terminal or file manager.
- [key](.config/hypr/config/key.conf) : my keybindings
- [colors](.config/hypr/config/colors.conf) : my color configuration linked with wallust, since is dynamicly generated when i change my wallpapers, i didn't push it to my git. (see [wallust] section)
- [window](.config/hypr/config/window.conf) : some window rules for apps (like spf floating instead of tilling)
- [theme](.config/hypr/config/theme.conf) : general theming such as blur or inactive timeout for the cursor.
- [anim](.config/hypr/config/anim) : it's a folder containing some amimations files, i choose one of those in my import list in [hyprland.conf](.config/hypr/hyprland.conf)
- [plugin](.config/hypr/config/plug.conf) : contains list of hyprland plugin. Actually, i only use one plugin, [HyprExpo](https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo).

#### Config tips

> [!WARNING]
> To add hyprland plugins, you must have hyprland-git installed cause you need the headers exposed by hyprpm to add some plugins.

<div align = center>

### Web Browser *****QUTEBROWSER*****

![Qutebrowser1](wallpapers/qutebrowser1.png)

</div>

Qutebrowser is a fancy light browser, extremely customizable and keyboard centered with use of VIM motions. For configuration, it use python scripts, which allows deep customization.

original repo : [Qutebrowser](https://github.com/qutebrowser/qutebrowser)

my configs files : [qutebrowser configs](.config/qutebrowser)

i separated my configuration into several files. The pricipal configuration file with privacy settings, searchengines and global configuration is [here](.config/qutebrowser/config.py) and for my style customization i created a [separated python file](.config/qutebrowser/themes/nebulix.py) that i source in my global customization file :

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

| Step 1 | Step 2 |
|----|----|
| ![mpv2](wallpapers/mpv1.png) | ![mpv2](wallpapers/mpv2.png) |

The second method is similar to the first but it uses a custom script which allows you to have a single instances of MPV and to add videos in queues, a bit like a playlist.

Script link : [umpv](https://github.com/mpv-player/mpv/blob/master/TOOLS/umpv)

you need to add this script to your $PATH then you simply do this :

```bash
config.bind('<Ctrl+/>', 'hint links spawn umpv --enqueue {hint-url}')
```

The third method use a greasmonkey scripts, but i not cover this solution here, you at least know that it exists.

## Management

I'm using git bare (git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME) to manage these dotfiles.

### Repository Quality & Development

This repository includes several tools and workflows to maintain code quality:

#### Quick Start
```bash
# Install development dependencies and setup
make install

# Run all quality checks
make lint

# Validate configurations
make validate

# Check dependencies
make check-deps
```

#### Available Make Targets
- `make help` - Show all available commands
- `make install` - Setup development environment with pre-commit hooks
- `make lint` - Run all linters (shellcheck, YAML validation, etc.)
- `make test` - Run basic validation tests
- `make security` - Run security scans
- `make clean` - Clean temporary files
- `make docs` - Update documentation

#### Quality Tools Included
- **Pre-commit hooks**: Automated quality checks before commits
- **Shellcheck**: Shell script linting and best practices
- **YAML validation**: Configuration file syntax checking
- **Security scanning**: Detect secrets and vulnerabilities
- **EditorConfig**: Consistent formatting across editors
- **GitHub Actions**: Automated CI/CD pipeline

#### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

### Installation

> [!WARNING]
> THIS IS NOT A PLUG AND PLAY DOTFILES! There's no install scripts or step by step guide to install my files, you should know what you do if you want to use it. I only explain how my files are organized, and some tips with some tools. The comments in my files are mainly **IN FRENCH**

#### Prerequisites
```bash
# Required tools
sudo pacman -S shellcheck python python-pip git

# Development tools (optional)
pip install pre-commit detect-secrets
```

#### Setup Development Environment
```bash
# Clone the repository
git clone https://github.com/Samtroulcode/dotfiles.git
cd dotfiles

# Setup development environment
make install
```

### Usage

#### Regular Maintenance
```bash
# Clean system (Arch Linux specific)
./scripts/arch-clean.sh

# Backup configurations
make backup

# Update repository structure documentation
make docs
```

#### Quality Checks
```bash
# Check all scripts for issues
make check-scripts

# Lint shell scripts
make lint-shell

# Run security scan
make security
```
