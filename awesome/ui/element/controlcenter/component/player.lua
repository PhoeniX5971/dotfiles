local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("rubato")
local gears = require("gears")
local lain = require("lain")

local mpd_widget = {}

-- Album art
local album_art = wibox.widget({
	resize = true,
	forced_width = dpi(64),
	forced_height = dpi(64),
	clip_shape = helpers.rrect(dpi(8)),
	widget = wibox.widget.imagebox,
})

-- Progress bar
local progress_bar = wibox.widget({
	max_value = 100,
	value = 0,
	forced_height = dpi(6),
	shape = helpers.rrect(dpi(3)),
	color = beautiful.fg_normal,
	background_color = beautiful.fg_normal .. "22",
	bar_shape = helpers.rrect(dpi(3)),
	widget = wibox.widget.progressbar,
})

local progress_anim = rubato.timed({
	duration = 0.3,
	easing = rubato.easing.linear,
	subscribed = function(pos)
		progress_bar.value = pos
	end,
})

-- Controls
local function control_button(icon)
	return wibox.widget({
		{
			{
				id = "text",
				text = icon,
				font = "Symbols Nerd Font " .. dpi(14),
				widget = wibox.widget.textbox,
			},
			margins = dpi(6),
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = "#00000000", -- transparent
	})
end

local prev_button = control_button("")
local play_button = control_button("")
local next_button = control_button("")

-- Lain MPD Widget
local mpd = lain.widget.mpd({
	timeout = 1,
	settings = function()
		if mpd_now.album_art then
			album_art:set_image(gears.surface.load_uncached(mpd_now.album_art))
		else
			album_art:set_image(
				beautiful.music_placeholder or gears.filesystem.get_configuration_dir() .. "icons/music.png"
			)
		end

		local glyph = mpd_now.state == "play" and "" or ""
		play_button:get_children_by_id("text")[1].text = glyph

		if mpd_now.elapsed and mpd_now.duration then
			local percent = (tonumber(mpd_now.elapsed) / tonumber(mpd_now.duration)) * 100
			progress_anim.target = percent
		end
	end,
})

-- Bind buttons
prev_button:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn("mpc prev")
end)))
play_button:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn("mpc toggle")
end)))
next_button:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn("mpc next")
end)))

-- Widget layout
mpd_widget.widget = wibox.widget({
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(12),
			album_art,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(10),
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(15),
					prev_button,
					play_button,
					next_button,
				},
				progress_bar,
			},
		},
		margins = dpi(10),
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_focus .. "20",
	shape = helpers.rrect(dpi(16)),
	widget = wibox.container.background,
	forced_height = dpi(90),
	forced_width = dpi(350),
})

return mpd_widget
