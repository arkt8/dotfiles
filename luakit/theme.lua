--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "20px 'Terminus (TTF)'"
theme.fg   = "#ffdcb5"
theme.bg   = "#000000"

-- Genaral colours
theme.success_fg = "#40a1a3"
theme.loaded_fg  = "#1d8188"
theme.error_fg = "#ff3902"
theme.error_bg = "#df1902"

-- Warning colours
theme.warning_fg = "#ff8601"
theme.warning_bg = "#000000"

-- Notification colours
theme.notif_fg = "#ffdcb5"
theme.notif_bg = "#4e4e4e"

-- Menu colours
theme.menu_fg                   = "#ffdcb5"
theme.menu_bg                   = "#4e4e4e"
theme.menu_selected_fg          = "#ffdcb5"
theme.menu_selected_bg          = "#253749"
theme.menu_title_bg             = "#202020"
theme.menu_primary_title_fg     = "#ffdcb5"
theme.menu_secondary_title_fg   = "#cab399"

theme.menu_disabled_fg = "#4e4e4e"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#ffdcb5"
theme.menu_active_bg = "#b4060a"

-- Proxy manager
theme.proxy_active_menu_fg      = '#c6d8e9'
theme.proxy_active_menu_bg      = '#394d60'
theme.proxy_inactive_menu_fg    = '#778fa6'
theme.proxy_inactive_menu_bg    = '#394d60'

-- Statusbar specific
theme.sbar_fg         = "#4e4e4e"
theme.sbar_bg         = "#202020"

-- Downloadbar specific
theme.dbar_fg         = "#b4060a"
theme.dbar_bg         = "#202020"
theme.dbar_error_fg   = "#ff3902"

-- Input bar specific
theme.ibar_fg           = "#40a1a3"
theme.ibar_bg           = "#202020"

-- Tab label
theme.tab_fg            = "#ffdcb5"
theme.tab_bg            = "#202020"
theme.tab_hover_bg      = "#202020"
theme.tab_ntheme        = "#4e4e4e"
theme.selected_fg       = "#ffdcb5"
theme.selected_bg       = "#000000"
theme.selected_ntheme   = "#000000"
theme.loading_fg        = "#4e4e4e"
theme.loading_bg        = "#000000"

theme.selected_private_tab_bg = "#ffdcb5"
theme.selected_private_tab_fg = "#ffdcb5"
theme.private_tab_bg    = "#253749"
theme.private_tab_fg    = "#cab399"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#00FF00"
theme.notrust_fg        = "#FF0000"

-- Follow mode hints
theme.hint_font = "10px monospace, courier, sans-serif"
theme.hint_fg = "#c6d8e9"
theme.hint_bg = "#000088"
theme.hint_border = "1px dashed #000"
theme.hint_opacity = "0.3"
theme.hint_overlay_bg = "rgba(255,255,153,0.3)"
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = "#3a7475", bg = "#202020" }
theme.warn = { fg = "#df6601", bg = "#202020" }
theme.error = { fg = "#df1902", bg = "#202020" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#000000", fg = "#ffdcb5", link = "#1d8188" }
theme.gopher_dark  = { bg = "#000000", fg = "#ffdcb5", link = "#1d8188" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
