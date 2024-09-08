local awful = require("awful")

local update_interval = 60

local bat_script = [[
	sh -c "cat /sys/class/power_supply/BAT*/uevent"
]]

awful.widget.watch(bat_script, update_interval, function(widget, stdout)
	local value = stdout:match("%CAPACITY=([^\n]+)")
	value = tonumber(value)
	local state = stdout:match("%STATUS=([^\n]+)")
	awesome.emit_signal("signal::battery", value, state)
end)
