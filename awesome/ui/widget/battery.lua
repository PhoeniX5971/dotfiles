local wibox = require("wibox")
local lain = require("lain")
local config = require("config")

local battery_icon = wibox.widget({
	align = "center",
	valign = "center",
	font = "Symbols Nerd Font Mono " .. 16 * config.dpi_multiplier,
	widget = wibox.widget.textbox,
})

local battery = lain.widget.bat({
	settings = function()
		local icon
		local perc = tonumber(bat_now.perc) or 0

		if perc >= 90 then
			icon = ""
		elseif perc >= 60 then
			icon = ""
		elseif perc >= 30 then
			icon = ""
		elseif perc >= 10 then
			icon = ""
		else
			icon = ""
		end

		widget:set_markup('<span font="Symbols Nerd Font ' .. 16 * config.dpi_multiplier .. ' ">' .. icon .. "</span>")
	end,
	widget = battery_icon,
})

return battery
