local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local config = require("config")
local dpi = beautiful.xresources.apply_dpi

-- Volume OSD Widget
local volume_osd = {}
local hide_timer = nil

-- Unicode icons for different volume states
local icons = {
	high = "",
	low = "",
	muted = "",
}

-- Create the OSD widget
volume_osd.widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = icons.high,
				font = "Symbols Nerd Font " .. dpi(24) * config.dpi_multiplier,
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
volume_osd.popup = awful.popup({
	widget = volume_osd.widget,
	border_color = beautiful.border_color_active,
	border_width = beautiful.border_width,
	ontop = true,
	visible = false,
	shape = helpers.rrect(dpi(6)),
	placement = function(c)
		awful.placement.bottom(c, { margins = { bottom = dpi(50) * config.dpi_multiplier } })
	end,
})

-- Function to get current volume status from pamixer
local function get_volume_info()
	local fd = io.popen("pamixer --get-volume")
	local volume = tonumber(fd:read("*a")) or 0
	fd:close()

	fd = io.popen("pamixer --get-mute")
	local muted = fd:read("*a"):match("true")
	fd:close()

	return volume, muted
end

-- Function to update the OSD
function volume_osd.update()
	local volume, muted = get_volume_info()
	local icon_widget = volume_osd.widget:get_children_by_id("icon")[1]
	local bar_widget = volume_osd.widget:get_children_by_id("bar")[1]
	local text_widget = volume_osd.widget:get_children_by_id("text")[1]

	-- Update values
	bar_widget.value = volume
	text_widget.text = (volume .. "%")

	-- Update icon
	if muted then
		icon_widget.text = icons.muted
	else
		if volume >= 50 then
			icon_widget.text = icons.high
		else
			icon_widget.text = icons.low
		end
	end

	-- Show the OSD
	volume_osd.popup.visible = true

	-- Cancel any previous hide timer
	if hide_timer then
		hide_timer:stop()
		hide_timer = nil
	end

	-- Set timer to hide the OSD after 2 seconds
	hide_timer = gears.timer({
		timeout = 2,
		autostart = true,
		single_shot = true,
		callback = function()
			volume_osd.popup.visible = false
			hide_timer = nil
		end,
	})
end

return volume_osd
