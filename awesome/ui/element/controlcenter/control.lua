local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local config = require("config")

-- Load slider widgets
local sliderbox = require("ui.element.controlcenter.component.sliderbox")
local volume = require("ui.element.controlcenter.component.volume")
local brightness = require("ui.element.controlcenter.component.brightness")
-- local player = require("ui.element.controlcenter.component.player")

-- Create container widget
local control_center_widget = wibox.widget({
	{
		{
			{
				{
					sliderbox(volume.icon, volume.slider),
					sliderbox(brightness.icon, brightness.slider),
					-- player,
					spacing = dpi(10),
					layout = wibox.layout.fixed.vertical,
				},
				widget = wibox.container.margin,
			},
			valign = "center",
			align = "center",
			shape = helpers.rrect(dpi(6) * config.dpi_multiplier),
			bg = beautiful.bg,
			widget = wibox.container.background,
		},
		margins = dpi(16),
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_normal,
	shape = helpers.rrect(dpi(10)),
	widget = wibox.container.background,
})

-- Create the popup itself
local control_popup = awful.popup({
	widget = wibox.widget({
		control_center_widget,
		layout = wibox.layout.fixed.vertical,
	}),
	border_color = beautiful.border_color,
	ontop = true,
	visible = false,
	shape = helpers.rrect(dpi(10)),
	minimum_height = dpi(96),
	placement = function(c)
		awful.placement.top_right(c, {
			margins = {
				top = dpi(60),
				right = dpi(20),
			},
		})
	end,
})

-- Toggle popup on signal
awesome.connect_signal("open::control", function()
	control_popup.visible = not control_popup.visible
end)

return control_popup
