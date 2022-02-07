--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "20px 'Terminus (TTF)'"
theme.fg   = "$foreground"
theme.bg   = "$background"

-- Genaral colours
theme.success_fg = "$color10"
theme.loaded_fg  = "$color12"
theme.error_fg = "$color9"
theme.error_bg = "$color1"

-- Warning colours
theme.warning_fg = "$color11"
theme.warning_bg = "$background"

-- Notification colours
theme.notif_fg = "$foreground"
theme.notif_bg = "$color8"

-- Menu colours
theme.menu_fg                   = "$foreground"
theme.menu_bg                   = "$color8"
theme.menu_selected_fg          = "$color0"
theme.menu_selected_bg          = "$color7"
theme.menu_title_bg             = "$color0"
theme.menu_primary_title_fg     = "$foreground"
theme.menu_secondary_title_fg   = "$color7"

theme.menu_disabled_fg = "$color8"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "$foreground"
theme.menu_active_bg = "$color5"

-- Proxy manager
theme.proxy_active_menu_fg      = '#c6d8e9'
theme.proxy_active_menu_bg      = '#394d60'
theme.proxy_inactive_menu_fg    = '#778fa6'
theme.proxy_inactive_menu_bg    = '#394d60'

-- Statusbar specific
theme.sbar_fg         = "$color7"
theme.sbar_bg         = "$color0"

-- Downloadbar specific
theme.dbar_fg         = "$color5"
theme.dbar_bg         = "$color0"
theme.dbar_error_fg   = "$color9"

-- Input bar specific
theme.ibar_fg           = "$color10"
theme.ibar_bg           = "$color0"

-- Tab label
theme.tab_fg            = "$color15"
theme.tab_bg            = "$color0"
theme.tab_hover_bg      = "$color0"
theme.tab_ntheme        = "$color8"
theme.selected_fg       = "$foreground"
theme.selected_bg       = "$background"
theme.selected_ntheme   = "$background"
theme.loading_fg        = "$color8"
theme.loading_bg        = "$background"

theme.selected_private_tab_bg = "$color15"
theme.selected_private_tab_fg = "$foreground"
theme.private_tab_bg    = "$color6"
theme.private_tab_fg    = "$color7"

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
theme.ok = { fg = "$color2", bg = "$color0" }
theme.warn = { fg = "$color3", bg = "$color0" }
theme.error = { fg = "$color1", bg = "$color0" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "$background", fg = "$foreground", link = "$color12" }
theme.gopher_dark  = { bg = "$background", fg = "$foreground", link = "$color12" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
