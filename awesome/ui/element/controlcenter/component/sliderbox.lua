local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

return function(icon, slider)
	return wibox.container.background(
		wibox.container.margin(
			wibox.widget({
				{
					text = icon,
					font = "Symbols Nerd Font Mono 16",
					widget = wibox.widget.textbox,
				},

				slider,
				spacing = dpi(12),
				layout = wibox.layout.fixed.horizontal,
			}),
			dpi(6)
		),
		beautiful.bg_normal,
		helpers.rrect(dpi(6))
	)
end
