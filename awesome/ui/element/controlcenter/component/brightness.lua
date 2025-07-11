local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local config = require("config")

local brightness_slider = wibox.widget({
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

brightness_slider:connect_signal("property::value", function(_, value)
	awful.spawn("brightnessctl s " .. math.floor(value) .. "%", false)
end)

-- Update slider with current brightness
awful.spawn.easy_async("brightnessctl g", function(stdout)
	local cur = tonumber(stdout)
	awful.spawn.easy_async("brightnessctl m", function(maxout)
		local max = tonumber(maxout)
		if cur and max then
			brightness_slider.value = math.floor((cur / max) * 100)
		end
	end)
end)

brightness_slider.update_brightness = function()
	awful.spawn.easy_async("brightnessctl g", function(stdout)
		local cur = tonumber(stdout)
		awful.spawn.easy_async("brightnessctl m", function(maxout)
			local max = tonumber(maxout)
			if cur and max then
				brightness_slider.value = math.floor((cur / max) * 100)
			end
		end)
	end)
end

return {
	icon = "󰃠",
	slider = brightness_slider,
}
