# Appliquer le thème
config.source("./themes/nebulix.py")
# config.source("/home/sam/.cache/wal/wallust-colors.py")
config.load_autoconfig(False)

# Empeche WebRTC d'utiliser n'importe quelle ip non lié au proxy
config.set("qt.args", ["force-webrtc-ip-handling-policy=disable_non_proxied_udp"])

# Tabs stylisées et plus visibles
c.tabs.padding = {"top": 8, "bottom": 8, "left": 12, "right": 12}
c.tabs.indicator.width = 0
c.window.transparent = True

# Completion quand recherche avec o ou O
c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem",
]

# Désactiver les raccourcies des tabs
config.unbind("J")
config.unbind("K")

# Rebind les tabs avec inversion
config.bind("J", "tab-prev")  # Maintenant J = onglet précédent
config.bind("K", "tab-next")  # Maintenant K = onglet suivant

# Pas de config persistante
c.auto_save.session = False

# Autoplay OFF globalement
c.content.autoplay = False

# Désactiver le DNS prefetch
c.content.dns_prefetch = False

# on assume l'ua, par contre, pas le fr
c.content.headers.accept_language = "en-US,en;q=0.5"

# url de start page
c.url.start_pages = ["http://sam-searxng:8080/"]

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
    "rd": "https://www.reddit.com/search/?q={}",
    "libgen": "https://libgen.rs/search.php?req={}",
    "hn": "https://hn.algolia.com/?q={}",
    "dc": "https://digitalcore.club/search?search={}",
    "pdb": "https://www.protondb.com/search?q={}",
}

# ouvrir des videos et streams dans mpv
config.bind(",yt", "hint links spawn mpv {hint-url}")
config.bind(",tw", "hint links spawn streamlink --player mpv {hint-url} best")

# télécharger des vidéos/playlist/mp3
config.bind(
    ",vd",
    'hint links spawn yt-dlp --embed-thumbnail --add-metadata -o "~/Videos/%(uploader)s/%(title)s.%(ext)s" {hint-url}',
)
config.bind(
    ",vpl",
    'hint links spawn yt-dlp --embed-thumbnail --add-metadata -o "~/Videos/%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" {hint-url}',
)
config.bind(
    ",md",
    'hint links spawn yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata -o "~/Storage/Music/Tracks/%(title)s.%(ext)s" {hint-url}',
)
config.bind(
    ",mpl",
    'hint links spawn yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata -o "~/Storage/Music/Albums/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" {hint-url}',
)

# Cache/affiche les onglets
config.bind(",tn", "set tabs.show never")
config.bind(",ta", "set tabs.show always")

# binds gopass
config.bind(
    ",gp", "spawn --detach ghostty --class=nebu.gopass -e gopass show -c {url:host}"
)
config.bind(
    ",gs",
    "spawn --detach ghostty --class=nebu.gopass --wait-after-command=true -e gopass show {url:host}",
)
config.bind(
    ",gn",
    "spawn --detach ghostty --class=nebu.gopass --wait-after-command=true -e gopass new {url:host}",
)
config.bind(",gP", "spawn --detach ghostty --class=nebu.gopass -e gopass")

# Historique / downloads / messages
config.bind(",ch", "history-clear --force")  # historique global
config.bind(",cd", "download-clear")  # liste des téléchargements terminés
config.bind(",cm", "clear-messages")  # messages dans la barre de statut

# binds utils
config.bind(",PP", "spawn --detach $HOME/bin/in-ns qutebrowser --temp-basedir")

# Toggle par domaine
config.bind(
    ",js", "config-cycle -p -u *://{url:host}/* content.javascript.enabled ;; reload"
)
config.bind(
    ",co",
    "config-cycle -p -t -u *://{url:host}/* content.cookies.accept all no-3rdparty never ;; reload",
)
config.bind(
    ",cv", "config-cycle -p -u *://{url:host}/* content.canvas_reading ;; reload"
)
config.bind(",gl", "config-cycle -p -u *://{url:host}/* content.webgl ;; reload")

# dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"

# Privacy Settings
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.javascript.enabled", True)
config.set("content.cookies.store", True)
config.set("content.cookies.accept", "no-3rdparty")
config.set("content.headers.accept_language", "en-US,en;q=0.5")
config.set("content.headers.referer", "same-domain")

# JS activé pour les fichiers locaux
config.set("content.javascript.enabled", True, "file://*")

c.content.blocking.enabled = True

# Adblock (ABP)
c.content.blocking.method = "both"  # nécessite python-adblock
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
]

# Hosts (format /etc/hosts)
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/nextdns/click-tracking-blocklists/main/hosts",
    "https://blocklistproject.github.io/Lists/tracking.txt",
]

# Allow-list js
for pat in [
    "https://*.cloudflare.com/*",
    "https://github.com/*",
    "https://crates.io/*",
    "http://sam-searxng:8080/*",
]:
    config.set("content.javascript.enabled", True, pat)
    config.set("content.canvas_reading", True, pat)
    config.set("content.webgl", True, pat)
