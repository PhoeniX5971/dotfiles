-- osd_container.lua
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local config = require("config")
local helpers = require("helpers")

local osd_container = {}

osd_container.layout = wibox.widget({
	layout = wibox.layout.fixed.vertical,
})

-- Wrapper: each OSD goes in a container
osd_container.registry = {} -- { name = widget }

-- Popup for the stack
osd_container.popup = awful.popup({
	widget = osd_container.layout,
	ontop = true,
	visible = false,
	shape = helpers.rrect(dpi(6)),
	border_color = beautiful.border_color_normal,
	placement = function(c)
		awful.placement.top(c, { margins = { top = dpi(50) * config.dpi_multiplier } })
	end,
})

-- Add or update a widget
function osd_container.register(name, widget)
	if not osd_container.registry[name] then
		osd_container.layout:add(widget)
		osd_container.registry[name] = widget
	end
end

-- Show a specific widget with its own timer
function osd_container.show(name, timeout)
	timeout = timeout or 2
	local widget = osd_container.registry[name]
	if not widget then
		return
	end

	widget.visible = true
	osd_container.popup.visible = true

	-- Start hide timer for just this widget
	if widget._hide_timer then
		widget._hide_timer:stop()
	end

	widget._hide_timer = gears.timer({
		timeout = timeout,
		autostart = true,
		single_shot = true,
		callback = function()
			widget.visible = false
			osd_container._check_visibility()
		end,
	})
end

-- Hide container if all widgets are invisible
function osd_container._check_visibility()
	for _, widget in pairs(osd_container.registry) do
		if widget.visible then
			return
		end
	end
	osd_container.popup.visible = false
end

return osd_container
