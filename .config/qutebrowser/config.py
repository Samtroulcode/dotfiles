# Appliquer le thème
config.source('themes/nebulix.py')
config.load_autoconfig(False)

# Appliquer css
c.content.user_stylesheets = ['~/.config/qutebrowser/user-styles.css']

# Tabs stylisées et plus visibles
c.tabs.padding = {'top': 8, 'bottom': 8, 'left': 12, 'right': 12}
c.tabs.indicator.width = 0
c.window.transparent = True

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

c.auto_save.session = True

# url de recherches
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}", 
    "wa": "https://wiki.archlinux.org/?search={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "wp": "https://fr.wikipedia.org/w/index.php?search={}",
    "gh": "https://github.com/search?o=desc&q={}&s=stars",
    "pkg": "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged="
}

# ouvrir des videos dans mpv
config.bind('<Ctrl+/>', 'hint links spawn /home/sam/scripts/youtube-view-then-mpv.sh {hint-url}')

# dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'

# Privacy Settings
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)

c.content.blocking.enabled = True
