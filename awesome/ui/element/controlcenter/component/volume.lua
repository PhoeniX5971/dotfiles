local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local helpers = require("helpers")
local config = require("config")

local volume_slider = wibox.widget({
	maximum = 100,
	minimum = 0,
	value = 50,
	forced_width = dpi(420) * config.dpi_multiplier,
	forced_height = dpi(32) * config.dpi_multiplier,
	bar_height = dpi(32) * config.dpi_multiplier,
	bar_shape = helpers.rrect(dpi(4) * config.dpi_multiplier),
	bar_color = beautiful.bg_urgent,
	bar_active_color = beautiful.bg_focus,
	handle_color = beautiful.bg_focus,
	handle_border_color = beautiful.bg_focus,
	handle_shape = helpers.rrect(dpi(4) * config.dpi_multiplier),
	handle_width = dpi(5 * config.dpi_multiplier),
	handle_border_width = dpi(4) * config.dpi_multiplier,
	widget = wibox.widget.slider,
})

volume_slider:connect_signal("property::value", function(_, value)
	awful.spawn("pamixer --set-volume " .. math.floor(value), false)
end)

-- Update slider with current volume
awful.spawn.easy_async("pamixer --get-volume", function(stdout)
	local vol = tonumber(stdout)
	if vol then
		volume_slider.value = vol
	end
end)

volume_slider.update_volume = function()
	awful.spawn.easy_async("pamixer --get-volume", function(stdout)
		local vol = tonumber(stdout)
		if vol then
			volume_slider.value = vol
		end
	end)
end

return {
	icon = "",
	slider = volume_slider,
}
