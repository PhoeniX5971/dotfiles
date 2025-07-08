local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local config = require("config")
local dpi = beautiful.xresources.apply_dpi

local clock = (config.placement == "left" or config.placement == "right") and wibox.widget.textclock("%I\n%M\n%p")
	or wibox.widget.textclock("%I:%M %p")

screen.connect_signal("request::desktop_decoration", function(s)
	local taglist = require("ui.widget.taglist")(s)
	local tasklist = require("ui.widget.tasklist")
	local systray = require("ui.widget.systray")
	local battery = require("ui.widget.battery")

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

	s.wibar = awful.wibar({
		screen = s,
		position = config.placement,
		widget = {
			{
				{
					tasklist.create(s), -- Create the tasklist
					spacing = dpi(4),
					layout = (config.placement == "left" or config.placement == "right")
							and wibox.layout.fixed.vertical
						or wibox.layout.fixed.horizontal,
				},
				expand = "none",
				taglist, -- Create the taglist
				{
					systray.create(),
					{
						{
							{
								s.layouts,
								{
									battery,
									margins = {
										right = dpi(4), -- Margin for battery widget
									},
									widget = wibox.container.margin, -- Margin for battery widget
								},
								clock,
								spacing = dpi(6),
								layout = (config.placement == "left" or config.placement == "right")
										and wibox.layout.fixed.vertical
									or wibox.layout.fixed.horizontal,
							},
							margins = dpi(6),
							widget = wibox.container.margin, -- Margin For Clock Box
						},
						bg = beautiful.bg_focus,
						shape = helpers.rrect(6),
						widget = wibox.container.background, -- Clock Box Container Background
					},
					spacing = dpi(8),
					layout = (config.placement == "left" or config.placement == "right")
							and wibox.layout.fixed.vertical
						or wibox.layout.fixed.horizontal,
				},
				layout = (config.placement == "left" or config.placement == "right") and wibox.layout.align.vertical
					or wibox.layout.align.horizontal,
			},
			margins = dpi(2),
			widget = wibox.container.margin, -- Apply margins to the overall container
		},
	})

	if config.placement == "left" or config.placement == "right" then
		s.wibar.width = dpi(45) -- Set width for vertical placement
	else
		s.wibar.height = dpi(45) -- Set height for horizontal placement
	end

	-- Set the wibar background and shape
	s.wibar.bg = beautiful.bg_normal -- Set background color to theme's normal bg
end)
