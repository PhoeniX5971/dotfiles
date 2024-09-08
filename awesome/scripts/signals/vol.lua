local awful = require("awful")
local gears = require("gears")

local icon = ""

function update_value_of_volume()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function(stdout)
		local value = stdout:match("(%d?%d?%d)%%")
		local muted = stdout:match("%[(o%D%D?)%]")
		value = tonumber(value)
		if muted == "off" then
			icon = ""
		elseif value <= 33 then
			icon = ""
		elseif value <= 66 then
			icon = ""
		elseif value <= 100 then
			icon = ""
		end
		awesome.emit_signal("signal::volume", value, icon)
	end)
end

function update_value_of_capture_muted()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle", function(stdout)
		local value = stdout:match("%[(o%D%D?)%]")
		awesome.emit_signal("signal::capture", value)
	end)
end

function updateVolumeSignals()
	update_value_of_volume()
	update_value_of_capture_muted()
end

gears.timer {
	call_now = true,
	autostart = true,
	timeout = 2,
	callback = updateVolumeSignals,
	single_shot = true
}
