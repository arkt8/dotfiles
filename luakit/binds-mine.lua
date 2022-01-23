local modes = require("modes")
local styles = require("styles")
local settings = require("settings")


local mine_ua_changer = {
	mobile = "Mozilla/5.0 (Android 9; Mobile; rv:90.0) "
	      .. "Gecko/90.0 Firefox/90",
	desktop = "Mozilla/5.0 (X11; Linux x86_64; rv:90.0) "
	      .. "Gecko/90.0 Firefox/90",
	status= 'desktop',
	toggle = function( self )
		if self.status == 'desktop' then
			self.status = 'mobile'
		else
			self.status = 'desktop'
		end
		settings.webview.user_agent=self[self.status]
	end
}

modes.add_binds("normal", {
	{"<Control-w>", "unmapped", function(w) end },
	{"<Control-m>", "toggle user agent", function(w) mine_ua_changer:toggle() end },
	{",",           "hist back", function(w,m) w:back(m.count) end },
	{".",           "hist next", function(w,m) w:forward(m.count) end },
	{"<Control-d>", "dark colors", function(w,m) styles.toggle_sheet('dark.css') end },
	{"<Control-i>", "invert colors", function(w,m) styles.toggle_sheet('invert.css') end }
})
