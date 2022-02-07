local sets = require "settings"
local homedir = os.getenv("HOME")

sets.window.search_engines = {
	ddg = "https://duckduckgo.com/?q=%s",
	goo = "https://google.com/search?q=%s",
   hoo = "https://hoogle.haskell.org/?hoogle=%s",
   hwiki = "https://wiki.haskell.org/?search=%s",
	gof = "https://www.google.com/search?name=f&hl=en&q=%s",
}

sets.window.search_engines.default = sets.window.search_engines.ddg
sets.window.default_search_engine = "ddg"
sets.window.home_page    = "file://"..homedir.."/.config/dotfiles/bookmarks.html"
sets.window.new_tab_page = "file://"..homedir.."/.config/dotfiles/bookmarks.html"
