local awful = require("awful")
local beautiful = require("beautiful")
local config = require("config")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local ll = awful.widget.layoutlist({
	base_layout = wibox.widget({
		spacing = dpi(5) * config.dpi_multiplier,
		column_count = 5,
		layout = wibox.layout.grid.vertical,
	}),
	widget_template = {
		{
			{
				id = "icon_role",
				forced_height = dpi(22) * config.dpi_multiplier,
				forced_width = dpi(22) * config.dpi_multiplier,
				widget = wibox.widget.imagebox,
			},
			margins = dpi(2) * config.dpi_multiplier,
			widget = wibox.container.margin,
		},
		id = "background_role",
		forced_width = dpi(48) * config.dpi_multiplier,
		forced_height = dpi(48) * config.dpi_multiplier,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
	},
})

local layout_popup = awful.popup({
	widget = wibox.widget({
		ll,
		margins = dpi(8) * config.dpi_multiplier,
		widget = wibox.container.margin,
	}),
	border_color = beautiful.border_color,
	placement = awful.placement.centered,
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
})

-- Make sure you remove the default Mod4+Space and Mod4+Shift+Space
-- keybindings before adding this.
awful.keygrabber({
	start_callback = function()
		layout_popup.visible = true
	end,
	stop_callback = function()
		layout_popup.visible = false
	end,
	export_keybindings = true,
	stop_event = "release",
	stop_key = { "Escape", "Super_L", "Super_R" },
	keybindings = {
		{
			{ modkey },
			" ",
			function()
				awful.layout.set((gears.table.cycle_value(ll.layouts, ll.current_layout, 1)))
			end,
		},
		{
			{ modkey, "Shift" },
			" ",
			function()
				awful.layout.set((gears.table.cycle_value(ll.layouts, ll.current_layout, -1)), nil)
			end,
		},
	},
})

return layout_popup
