# Appliquer le thème
config.source('themes/wallust-colors.py')
config.load_autoconfig(False)

# passe par le proxy microsock qui est connecter via veth au namespace vpn
config.set('content.proxy', 'socks://10.10.10.2:1080')
# Empeche WebRTC d'utiliser n'importe quelle ip non lié au proxy
config.set('content.webrtc_ip_handling_policy', 'disable-non-proxied-udp')

# Appliquer css
# c.content.user_stylesheets = ['~/.config/qutebrowser/user-styles.css']

# Tabs stylisées et plus visibles
c.tabs.padding = {'top': 8, 'bottom': 8, 'left': 12, 'right': 12}
c.tabs.indicator.width = 0
c.window.transparent = True

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

c.auto_save.session = False

c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0'
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.canvas_reading = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

# url de start page
c.url.start_pages = ['http://sam-portal/board']

# url de recherches
c.url.searchengines = {
    "DEFAULT": "http://sam-searxng:8080/search?q={}",
    "go": "https://leta.mullvad.net/search?q={}&engine=google",
    "wa": "https://wiki.archlinux.org/?search={}",
    "pkg": "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=",
    "yt": "https://www.youtube.com/results?search_query={}",
    "wp": "https://fr.wikipedia.org/w/index.php?search={}",
    "gh": "https://github.com/search?o=desc&q={}&s=stars",
    "tmdb": "https://www.themoviedb.org/search?query={}",
    "libgen": "https://libgen.rs/search.php?req={}",
    "hn": "https://hn.algolia.com/?q={}",
    "dc": "https://digitalcore.club/search?search={}",
    "pdb": "https://www.protondb.com/search?q={}"
}

# ouvrir des videos et streams dans mpv
config.bind(',yt', 'hint links spawn /home/sam/bin/mpv-tools/TOOLS/umpv --enqueue {hint-url}')
config.bind(',tw', 'hint links spawn streamlink --player mpv {hint-url} best')

# dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'

# Privacy Settings
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.store", True)
config.set("content.cookies.accept", "no-3rdparty")
config.set("content.headers.accept_language", "en-US,en;q=0.5")
config.set("content.headers.referer", "same-domain")

c.content.blocking.enabled = True

c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
    "https://raw.githubusercontent.com/nextdns/click-tracking-blocklists/main/hosts",
    "https://blocklistproject.github.io/Lists/tracking.txt"
]
