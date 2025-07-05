local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")

-- Function that returns the systray widget with rounded corners
local function rounded_systray()
	-- Create the systray widget
	local systray = wibox.widget.systray()
	systray.horizontal = false

	-- Apply styling to the systray icons to make them look similar to the tasklist
	local systray_widget = wibox.widget({
		{
			systray,
			margins = 5,
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_focus,
		shape = helpers.rrect(6), -- Apply rounded corners to the systray
		widget = wibox.container.background,
	})

	return systray_widget
end

return {
	create = rounded_systray,
}
