local sets = require "settings"
local homedir = os.getenv("HOME")

sets.window.search_engines = {
	ddg = "https://lite.duckduckgo.com/lite/?q=%s",
	goo = "https://google.com/search?q=%s",
   hoo = "https://hoogle.haskell.org/?hoogle=%s",
   hwiki = "https://wiki.haskell.org/?search=%s",
	gof = "https://www.google.com/search?name=f&hl=en&q=%s",
   snim = "https://nim-lang.github.io/Nim/%s.html"
}

sets.window.search_engines.default = sets.window.search_engines.ddg
sets.window.default_search_engine = "ddg"
sets.window.home_page    = "file://"..homedir.."/.dotfiles/bookmarks.html"
sets.window.new_tab_page = "file://"..homedir.."/.dotfiles/bookmarks.html"
