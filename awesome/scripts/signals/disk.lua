local awful = require("awful")

local update_interval = 600
local disk_script = [[
	sh -c "df -h /"
]]

awful.widget.watch(disk_script, update_interval, function(widget, stdout)
	local value = stdout:match("%s(%d+)%%")
	awesome.emit_signal("signal::disk", value)
end)
