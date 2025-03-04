-- local awful = require("awful")
-- local gears = require("gears")
-- local wibox = require("wibox")
-- local beautiful = require("beautiful")
-- local helpers = require("helpers")
-- local dpi = beautiful.xresources.apply_dpi
--
-- -- Battery icon
-- local bat_icon = wibox.widget({
-- 	markup = helpers.colorize_text("󱐋 ", beautiful.battery),
-- 	align = "center",
-- 	valign = "center",
-- 	widget = wibox.widget.textbox,
-- })
--
-- -- Battery progress bar
-- local battery_progress = wibox.widget({
-- 	color = beautiful.fg_normal,
-- 	background_color = "#00000000",
-- 	forced_width = dpi(35),
-- 	border_width = dpi(1),
-- 	border_color = beautiful.battery .. "A6",
-- 	paddings = dpi(2),
-- 	bar_shape = helpers.rrect(dpi(2)),
-- 	shape = helpers.rrect(dpi(5)),
-- 	max_value = 100,
-- 	widget = wibox.widget.progressbar,
-- })
--
-- -- Battery half-circle cap
-- local battery_border_thing = wibox.widget({
-- 	{
-- 		wibox.widget.textbox,
-- 		widget = wibox.container.background,
-- 		bg = beautiful.battery .. "A6",
-- 		forced_width = dpi(8.2),
-- 		forced_height = dpi(8.2),
-- 		shape = function(cr, width, height)
-- 			gears.shape.pie(cr, width, height, 0, math.pi)
-- 		end,
-- 	},
-- 	direction = "east",
-- 	widget = wibox.container.rotate(),
-- })
--
-- -- Percentage text
-- local bat_txt = wibox.widget({
-- 	widget = wibox.widget.textbox,
-- 	markup = helpers.colorize_text("100", beautiful.fg_normal),
-- 	font = beautiful.font,
-- 	valign = "center",
-- 	align = "center",
-- })
--
-- -- Combined battery widget
-- local battery_widget = wibox.widget({
-- 	{
-- 		{
-- 			bat_txt,
-- 			bat_icon,
-- 			{
-- 				{
-- 					battery_progress,
-- 					widget = wibox.layout.stack,
-- 				},
-- 				battery_border_thing,
-- 				layout = wibox.layout.fixed.horizontal,
-- 				spacing = dpi(-1.6),
-- 			},
-- 			layout = wibox.layout.fixed.horizontal,
-- 			spacing = dpi(10),
-- 		},
-- 		widget = wibox.container.margin,
-- 		margins = { top = dpi(6), bottom = dpi(6), left = 2, right = -8 },
-- 	},
-- 	layout = wibox.layout.fixed.horizontal,
-- 	spacing = dpi(4),
-- })
--
-- -- Update battery status with power supply check
-- local function update_battery_status()
-- 	awful.spawn.easy_async_with_shell("upower -i /org/freedesktop/UPower/devices/DisplayDevice", function(output)
-- 		local state = output:match("state:%s+(%w+)")
-- 		local percentage = tonumber(output:match("percentage:%s+(%d+)%%"))
--
-- 		if percentage then
-- 			battery_progress.value = percentage
-- 			bat_txt.markup = helpers.colorize_text(percentage .. "%", beautiful.fg_normal)
-- 			battery_progress.color = (percentage >= 75) and beautiful.battery_green
-- 				or (percentage >= 25 and beautiful.battery_yellow or beautiful.battery_red)
-- 		end
--
-- 		-- Show lightning icon only when plugged in
-- 		bat_icon.visible = (state ~= "discharging")
-- 	end)
-- end
--
-- update_battery_status()
--
-- -- Listen for battery events
-- awful.spawn.with_line_callback("acpi_listen", {
-- 	stdout = function(event)
-- 		if event:match("ac_adapter") or event:match("battery") or event:match("ACPI") then
-- 			update_battery_status()
-- 		end
-- 	end,
-- })
--
-- return battery_widget
--
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Battery icon
local bat_icon = wibox.widget({
	markup = helpers.colorize_text("󱐋 ", beautiful.battery),
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

-- Battery progress bar
local battery_progress = wibox.widget({
	color = beautiful.fg_normal,
	background_color = "#00000000",
	forced_width = dpi(35),
	border_width = dpi(1),
	border_color = beautiful.battery .. "A6",
	paddings = dpi(2),
	bar_shape = helpers.rrect(dpi(2)),
	shape = helpers.rrect(dpi(5)),
	max_value = 100,
	widget = wibox.widget.progressbar,
})

-- Battery half-circle cap
local battery_border_thing = wibox.widget({
	{
		wibox.widget.textbox,
		widget = wibox.container.background,
		bg = beautiful.battery .. "A6",
		forced_width = dpi(8.2),
		forced_height = dpi(8.2),
		shape = function(cr, width, height)
			gears.shape.pie(cr, width, height, 0, math.pi)
		end,
	},
	direction = "east",
	widget = wibox.container.rotate(),
})

-- Percentage text
local bat_txt = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("100", beautiful.fg_normal),
	font = beautiful.font,
	valign = "center",
	align = "center",
})

-- Combined battery widget
local battery_widget = wibox.widget({
	{
		{
			bat_txt,
			-- bat_icon,
			{
				{
					battery_progress,
					widget = wibox.layout.stack,
				},
				battery_border_thing,
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(-1.6),
			},
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
		widget = wibox.container.margin,
		margins = { top = dpi(6), bottom = dpi(6), left = 2, right = 0 },
	},
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(4),
})

-- Update battery status with power supply check
local function update_battery_status()
	awful.spawn.easy_async_with_shell("upower -i /org/freedesktop/UPower/devices/DisplayDevice", function(output)
		local state = output:match("state:%s+(%S+)")
		local percentage = tonumber(output:match("percentage:%s+(%d+)%%"))

		if percentage then
			battery_progress.value = percentage
			bat_txt.markup = helpers.colorize_text(percentage .. "%", beautiful.fg_normal)
			battery_progress.color = (percentage >= 75) and beautiful.battery_green
				or (percentage >= 25 and beautiful.battery_yellow or beautiful.battery_red)
		end

		-- Show lightning icon only when plugged in
		if state == "fully-charged" or state == "charging" then
			bat_icon.visible = true
		elseif state == "discharging" then
			bat_icon.visible = false
		end
	end)
end

-- Listen for battery events and update instantly
awful.spawn.with_line_callback("acpi_listen", {
	stdout = function(event)
		-- Trigger update only for relevant events
		if event:match("ac_adapter") or event:match("battery") or event:match("ACPI") then
			update_battery_status()
		end
	end,
})

-- Initial battery status update
update_battery_status()

return battery_widget
