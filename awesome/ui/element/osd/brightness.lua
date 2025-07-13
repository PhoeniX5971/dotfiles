local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local config = require("config")
local dpi = beautiful.xresources.apply_dpi
local osd_container = require("ui.element.osd.osd_container")

-- Brightness OSD Widget
local brightness_osd = {}
local hide_timer = nil

-- Icons for brightness levels
local icons = {
	high = "󰃠",
	medium = "󰃟",
	low = "󰃞",
}

-- Create the OSD widget
brightness_osd.widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = icons.high,
				font = "Symbols Nerd Font Mono " .. dpi(24) * config.dpi_multiplier,
				widget = wibox.widget.textbox,
			},
			{
				{
					id = "bar",
					max_value = 100,
					value = 50,
					forced_height = dpi(30) * config.dpi_multiplier,
					forced_width = dpi(180) * config.dpi_multiplier,
					color = beautiful.bg_focus,
					background_color = beautiful.bg_urgent,
					shape = helpers.rrect(dpi(4) * config.dpi_multiplier),
					bar_shape = helpers.rrect(dpi(4) * config.dpi_multiplier),
					widget = wibox.widget.progressbar,
				},
				{
					id = "text",
					text = "50%",
					widget = wibox.widget.textbox,
				},
				spacing = dpi(8) * config.dpi_multiplier,
				layout = wibox.layout.fixed.horizontal,
			},
			spacing = dpi(12) * config.dpi_multiplier,
			layout = wibox.layout.fixed.horizontal,
		},
		margins = dpi(12) * config.dpi_multiplier,
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_normal,
	shape = helpers.rrect(dpi(6) * config.dpi_multiplier),
	widget = wibox.container.background,
})

-- Create the OSD popup
brightness_osd.widget.visible = false
osd_container.register("brightness", brightness_osd.widget)

-- Get current brightness (0-100) using brightnessctl
local function get_brightness()
	local fd = io.popen("brightnessctl get")
	local current = tonumber(fd:read("*a")) or 0
	fd:close()

	fd = io.popen("brightnessctl max")
	local max = tonumber(fd:read("*a")) or 100
	fd:close()

	local percent = math.floor((current / max) * 100)
	return math.min(percent, 100)
end

-- Update the OSD
function brightness_osd.update()
	local brightness = get_brightness()
	local icon_widget = brightness_osd.widget:get_children_by_id("icon")[1]
	local bar_widget = brightness_osd.widget:get_children_by_id("bar")[1]
	local text_widget = brightness_osd.widget:get_children_by_id("text")[1]

	bar_widget.value = brightness
	text_widget.text = brightness .. "%"

	if brightness >= 66 then
		icon_widget.text = icons.high
	elseif brightness >= 33 then
		icon_widget.text = icons.medium
	else
		icon_widget.text = icons.low
	end

	-- Show OSD
	osd_container.show("brightness", 2)
end

return brightness_osd
