local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local Color = require("modules.lua-color")
local rubato = require("modules.rubato")

local _ui = {}

function _ui.colorizeText(txt, fg)
	if fg == "" then
		fg = beautiful.fg
	end
	return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function _ui.create_point(color, size)
	return wibox.widget {
		widget = wibox.container.background,
		bg = color,
		forced_width = size,
		forced_height = size,
	}
end

function _ui.transitionColor(opts)
	local old = Color(opts.old)
	local new = Color(opts.new)
	local animator = rubato.timed {
	duration = opts.duration,
		rate = 60,
		override_dt = false,
		subscribed = function(perc)
			opts.transformer(tostring(old:mix(new, perc / 100)))
		end,
		easing = opts.easing or rubato.quadratic
	}
	animator.target = 100
end

return _ui
