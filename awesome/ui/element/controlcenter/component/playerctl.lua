local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("rubato")
local lain = require("lain")

-- MPD widget from lain
local mpd = lain.widget.mpd({
	timeout = 1,
	settings = function()
		-- This function can use 'mpd_now' (from lain code) or just do widget:set_markup(...)
		if not mpd_now or not mpd_now.state then
			widget:set_markup(" Stopped")
			awesome.emit_signal("signal::mpd_status", "stop")
			return
		end

		if mpd_now.state == "play" then
			local artist = mpd_now.artist or "Unknown Artist"
			local title = mpd_now.title or "Unknown Title"
			widget:set_markup(" " .. artist .. " - " .. title)
		elseif mpd_now.state == "pause" then
			widget:set_markup(" Paused")
		else
			widget:set_markup(" Stopped")
		end

		awesome.emit_signal("signal::mpd_status", mpd_now.state)
	end,
})

-- Progress bar with rubato animation
local progressbar = wibox.widget({
	max_value = 1,
	value = 0,
	forced_height = dpi(6),
	forced_width = dpi(250),
	bar_shape = gears.shape.rounded_bar,
	color = beautiful.accent or beautiful.fg_normal,
	background_color = beautiful.bg_focus,
	widget = wibox.widget.progressbar,
})

-- Smooth value animation
local progress_anim = rubato.timed({
	duration = 0.25,
	easing = rubato.easing.linear,
	subscribed = function(pos)
		progressbar.value = pos
	end,
})

-- Update progressbar according to song position
awesome.connect_signal("signal::mpd_position", function(pos, len)
	if len and len > 0 then
		progress_anim.target = pos / len
	else
		progress_anim.target = 0
	end
end)

-- Poll song position every 0.5s and emit signal
gears.timer({
	timeout = 0.5,
	autostart = true,
	callback = function()
		awful.spawn.easy_async("mpc status", function(stdout)
			local pos_min, pos_sec, len_min, len_sec = stdout:match("([0-9]+):([0-9]+)/([0-9]+):([0-9]+)")
			if pos_min and pos_sec and len_min and len_sec then
				local pos = tonumber(pos_min) * 60 + tonumber(pos_sec)
				local len = tonumber(len_min) * 60 + tonumber(len_sec)
				awesome.emit_signal("signal::mpd_position", pos, len)
			else
				awesome.emit_signal("signal::mpd_position", 0, 1)
			end
		end)
	end,
})

-- Control buttons (prev, play/pause, next)
local btn_prev = wibox.widget({
	markup = "",
	font = "Symbols Nerd Font 18",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})
btn_prev:connect_signal("button::press", function()
	awful.spawn("mpc prev")
end)

local btn_play = wibox.widget({
	markup = "",
	font = "Symbols Nerd Font 18",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})
btn_play:connect_signal("button::press", function()
	awful.spawn("mpc toggle")
end)

awesome.connect_signal("signal::mpd_status", function(state)
	if state == "play" then
		btn_play.markup = ""
	else
		btn_play.markup = ""
	end
end)

local btn_next = wibox.widget({
	markup = "",
	font = "Symbols Nerd Font 18",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})
btn_next:connect_signal("button::press", function()
	awful.spawn("mpc next")
end)

-- Layout
local player_control = wibox.widget({
	{
		mpd.cover_pattern,
		{
			btn_prev,
			btn_play,
			btn_next,
			spacing = dpi(15),
			layout = wibox.layout.fixed.horizontal,
		},
		progressbar,
		spacing = dpi(10),
		layout = wibox.layout.fixed.vertical,
	},
	spacing = dpi(10),
	layout = wibox.layout.align.horizontal,
})

return player_control
