--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "20px 'Terminus (TTF)'"
theme.fg   = "#dedacf"
theme.bg   = "#171717"

-- Genaral colours
theme.success_fg = "#ddf88f"
theme.loaded_fg  = "#a5c7ff"
theme.error_fg = "#f58c80"
theme.error_bg = "#ff615a"

-- Warning colours
theme.warning_fg = "#eee5b2"
theme.warning_bg = "#171717"

-- Notification colours
theme.notif_fg = "#dedacf"
theme.notif_bg = "#313131"

-- Menu colours
theme.menu_fg                   = "#dedacf"
theme.menu_bg                   = "#313131"
theme.menu_selected_fg          = "#dedacf"
theme.menu_selected_bg          = "#82fff7"
theme.menu_title_bg             = "#000000"
theme.menu_primary_title_fg     = "#dedacf"
theme.menu_secondary_title_fg   = "#dedacf"

theme.menu_disabled_fg = "#313131"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#dedacf"
theme.menu_active_bg = "#e86aff"

-- Proxy manager
theme.proxy_active_menu_fg      = '#c6d8e9'
theme.proxy_active_menu_bg      = '#394d60'
theme.proxy_inactive_menu_fg    = '#778fa6'
theme.proxy_inactive_menu_bg    = '#394d60'

-- Statusbar specific
theme.sbar_fg         = "#313131"
theme.sbar_bg         = "#000000"

-- Downloadbar specific
theme.dbar_fg         = "#e86aff"
theme.dbar_bg         = "#000000"
theme.dbar_error_fg   = "#f58c80"

-- Input bar specific
theme.ibar_fg           = "#ddf88f"
theme.ibar_bg           = "#000000"

-- Tab label
theme.tab_fg            = "#ffffff"
theme.tab_bg            = "#000000"
theme.tab_hover_bg      = "#000000"
theme.tab_ntheme        = "#313131"
theme.selected_fg       = "#dedacf"
theme.selected_bg       = "#171717"
theme.selected_ntheme   = "#171717"
theme.loading_fg        = "#313131"
theme.loading_bg        = "#171717"

theme.selected_private_tab_bg = "#ffffff"
theme.selected_private_tab_fg = "#dedacf"
theme.private_tab_bg    = "#82fff7"
theme.private_tab_fg    = "#dedacf"

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
theme.ok = { fg = "#b1e969", bg = "#000000" }
theme.warn = { fg = "#ebd99c", bg = "#000000" }
theme.error = { fg = "#ff615a", bg = "#000000" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#171717", fg = "#dedacf", link = "#a5c7ff" }
theme.gopher_dark  = { bg = "#171717", fg = "#dedacf", link = "#a5c7ff" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
