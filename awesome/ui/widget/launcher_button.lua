local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local button = wibox.widget({
	{
		{
			text = "",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		margins = {
			left = dpi(-5),
		},
		widget = wibox.container.margin,
	},
	shape = gears.shape.circle,
	bg = beautiful.bg_focus,
	fg = beautiful.fg_normal,
	forced_width = dpi(45),
	forced_height = dpi(45),
	widget = wibox.container.background,
})

function button:toggle_popup(popup)
	popup.visible = not popup.visible -- Toggle visibility of the popup
end

return button
