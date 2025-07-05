local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local clock = wibox.widget.textclock("%I\n%M\n%p")

screen.connect_signal("request::desktop_decoration", function(s)
	-- Create taglist and tasklist
	local taglist = require("ui.widget.taglist")(s)
	local tasklist = require("ui.widget.tasklist")
	local battery = require("ui.widget.battery")
	local systray = require("ui.widget.systray")

	-- Layoutbox (used for switching layouts)
	s.layouts = awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
		},
	})

	-- Create the wibar (panel)
	s.wibar = awful.wibar({
		screen = s,
		position = "left", -- Positioning the bar on the left side
		width = dpi(45), -- Width of the bar
		widget = {
			{
				{
					tasklist.create(s), -- Create the tasklist
					spacing = dpi(4),
					layout = wibox.layout.fixed.vertical, -- Vertical layout for tasklist
				},
				expand = "none",
				taglist, -- Create the taglist
				{
					systray.create(),
					{
						{
							{
								s.layouts,
								battery,
								clock,
								spacing = dpi(12),
								layout = wibox.layout.fixed.vertical, -- Clock Box Layout
							},
							margins = dpi(6),
							widget = wibox.container.margin, -- Margin For Clock Box
						},
						bg = beautiful.bg_focus,
						forced_width = dpi(30),
						shape = helpers.rrect(6),
						widget = wibox.container.background, -- Clock Box Container Background
					},
					spacing = dpi(8),
					layout = wibox.layout.fixed.vertical, -- Bottom Widgets
				},
				layout = wibox.layout.align.vertical, -- Entire bar
			},
			margins = dpi(2),
			widget = wibox.container.margin, -- Apply margins to the overall container
		},
	})

	-- Set the wibar background and shape
	s.wibar.bg = beautiful.bg_normal -- Set background color to theme's normal bg
	s.wibar.shape = helpers.rrect(6) -- Apply rounded corners to the entire bar
end)
