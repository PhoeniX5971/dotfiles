local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local config = require("config")

-- Function that returns the tasklist widget with rounded corners
local function rounded_tasklist(s)
	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			-- Focus the client and bring its workspace into view
			c:jump_to()
		end),
		awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = dpi(250) * config.dpi_multiplier } })
		end)
	)

	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.alltags,
		buttons = tasklist_buttons,
		layout = {
			spacing = dpi(2) * config.dpi_multiplier,
			layout = (config.placement == "left" or config.placement == "right") and wibox.layout.fixed.vertical
				or wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				id = "clienticon",
				widget = awful.widget.clienticon,
			},
			margins = dpi(2) * config.dpi_multiplier,
			widget = wibox.container.margin,
		},
	})

	-- Apply rounded corners and background
	local tasklist_widget = wibox.widget({
		{
			tasklist,
			margins = dpi(4) * config.dpi_multiplier,
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_focus, -- Set to your theme's normal background color
		shape = helpers.rrect(dpi(6) * config.dpi_multiplier), -- Rounded corners for the tasklist widget
		widget = wibox.container.background,
	})

	return tasklist_widget
end

return {
	create = rounded_tasklist,
}
