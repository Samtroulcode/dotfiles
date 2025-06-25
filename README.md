# Sam's Dotfiles ***NEBULIX***

My personal Linux dotfiles

I use Arch btw.

| ![Nebulix1](wallpapers/nebulix1.png) | ![Nebulix2](wallpapers/nebulix2.png) |
|--------------------------------------|--------------------------------------|
| ![Nebulix3](wallpapers/nebulix3.png) | ![Nebulix4](wallpapers/nebulix4.png) |

## Note on this repository

I use this repo to sync and backup my dotfiles.

The root of this repo is an equivalent to my $HOME directory

### Web Browser ***QUTEBROWSER***

![Qutebrowser1](wallpapers/qutebrowser1.png)

Qutebrowser is a fancy light browser, extremely customizable and keyboard centered with use of VIM motions. For configuration, it use python scripts, which allows deep customization.

original repo : [Qutebrowser](https://github.com/qutebrowser/qutebrowser)

my configs files : [qutebrowser configs](.config/qutebrowser)

i separated my configuration into several files. The pricipal configuration file with privacy settings, searchengines and global configuration is [here](.config/qutebrowser/config.py) and for my style customization i created a [separated python file](.config/qutebrowser/themes/nebulix.py) that i source in my global customization file : 
```python
config.source('themes/nebulix.py')
```

#### Config tips 

to watch youtubes videos without ads, there is 2 methods actually. You can watch the youtube video in mpv by binding a shortcut like that :
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

The second method use a greasmonkey scripts, but i not cover this solution here, you at least know that it exists.

## Management

I'm using gite bare (git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME) to manage these dotfiles
