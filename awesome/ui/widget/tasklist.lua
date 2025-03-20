local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")

-- Function that returns the tasklist widget with rounded corners
local function rounded_tasklist(s)
	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			-- Focus the client and bring its workspace into view
			c:jump_to()
		end),
		awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
		end)
	)

	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.alltags, -- Show all clients, not just current workspace
		buttons = tasklist_buttons,
		layout = {
			spacing = 2,
			layout = wibox.layout.fixed.vertical,
		},
		widget_template = {
			{
				id = "clienticon",
				widget = awful.widget.clienticon,
			},
			margins = 2,
			widget = wibox.container.margin,
		},
	})

	-- Apply rounded corners and background
	local tasklist_widget = wibox.widget({
		{
			tasklist,
			margins = 4,
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_focus, -- Set to your theme's normal background color
		shape = helpers.rrect(6), -- Rounded corners for the tasklist widget
		widget = wibox.container.background,
	})

	-- If there are no visible tasks, hide the tasklist widget
	if awful.widget.tasklist.filter.alltags == 0 then
		tasklist_widget.visible = false
	elseif tasklist.count > 0 then
		tasklist_widget.visible = false
	end

	return tasklist_widget
end

return {
	create = rounded_tasklist,
}
