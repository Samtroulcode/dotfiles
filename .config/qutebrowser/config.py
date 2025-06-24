# Appliquer le thème
config.source('themes/nebulix.py')
config.load_autoconfig(True)

# Appliquer css
c.content.user_stylesheets = ['~/.config/qutebrowser/user-styles.css']

# Tabs stylisées et plus visibles
c.tabs.padding = {'top': 8, 'bottom': 8, 'left': 12, 'right': 12}
c.tabs.indicator.width = 0
c.window.transparent = True

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

c.auto.save.session = True

# dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'

c.content.blocking.enabled = True
