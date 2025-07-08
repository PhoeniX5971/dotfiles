local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local helpers = require("helpers")

local volume_slider = wibox.widget({
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

return {
	icon = "",
	slider = volume_slider,
}
