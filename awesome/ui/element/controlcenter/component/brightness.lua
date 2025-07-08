local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local brightness_slider = wibox.widget({
	maximum = 100,
	minimum = 0,
	value = 50,
	forced_width = dpi(420),
	forced_height = dpi(32),
	bar_height = dpi(32),
	bar_shape = helpers.rrect(dpi(4)),
	bar_color = beautiful.bg_urgent,
	bar_active_color = beautiful.bg_focus,
	handle_color = beautiful.bg_focus,
	handle_border_color = beautiful.bg_focus,
	handle_shape = helpers.rrect(dpi(4)),
	handle_width = dpi(24),
	handle_border_width = dpi(1),
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

return {
	icon = "󰃠",
	slider = brightness_slider,
}
