local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local battery = require("ui.widget.battery")

local clock = wibox.widget.textclock("%I:%M %p")

screen.connect_signal("request::desktop_decoration", function(s)
	local taglist = require("ui.widget.taglist")(s)
	local tasklist = require("ui.widget.tasklist")
	local systray = require("ui.widget.systray")
	local launcher_button = require("ui.widget.launcher_button")
	local launcher_popup = require("ui.bar.launcher")
	local wallpaper_button = require("ui.widget.wallpaper_button")
	local wallpaper_popup = require("ui.bar.wallpaper")
	launcher_button:buttons(awful.button({}, 1, function()
		launcher_popup.visible = not launcher_popup.visible
	end))
	wallpaper_button:buttons(awful.button({}, 1, function()
		wallpaper_popup.visible = not wallpaper_popup.visible
	end))

	--[[
		Layouts:
		This widget shows the active layout. Left
		click to go to the next layout and right
		click to go to the previous layout.
	--]]
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

	--[[
		Wibar:
		This is where we create our bar.
	--]]
	s.wibar = awful.wibar({
		screen = s,
		position = "top",
		height = dpi(45),
		widget = {
			{
				{
					launcher_button,
					wallpaper_button,
					tasklist.create(s),
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				},
				expand = "none",
				taglist,
				{
					systray.create(s),
					{
						{
							{
								battery,
								clock,
								s.layouts,
								spacing = dpi(10),
								layout = wibox.layout.fixed.horizontal,
							},
							margins = {
								right = dpi(4),
								left = dpi(4),
							},
							widget = wibox.container.margin,
						},
						bg = beautiful.bg_focus,
						forced_height = dpi(25),
						shape = helpers.rrect(100),
						widget = wibox.container.background,
					},
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.align.horizontal,
			},
			margins = dpi(4),
			widget = wibox.container.margin,
		},
	})
end)
