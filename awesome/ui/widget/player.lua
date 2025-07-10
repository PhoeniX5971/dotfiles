local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local bling = require("bling")
local helpers = require("helpers")
local playerctl = bling.signal.playerctl.lib()

local art = wibox.widget({
	image = beautiful.no_song,
	valign = "right",
	widget = wibox.widget.imagebox,
})

local title_widget = wibox.widget({
	markup = "Nothing Playing",
	align = "left",
	widget = wibox.widget.textbox,
})

local artist_widget = wibox.widget({
	align = "left",
	widget = wibox.widget.textbox,
})

local create_music_button = function(text)
	return wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_urgent,
		{
			widget = wibox.container.margin,
			margins = 5,
			{
				widget = wibox.widget.textbox,
				id = "icon",
				markup = text,
				font = beautiful.font .. " 16",
			},
		},
	})
end

local next = create_music_button("")
next:buttons({
	awful.button({}, 1, function()
		playerctl:next()
	end),
})

local prev = create_music_button("")
prev:buttons({
	awful.button({}, 1, function()
		playerctl:previous()
	end),
})

local music_button = create_music_button("")
music_button:buttons({
	awful.button({}, 1, function()
		playerctl:play_pause()
	end),
})

local media_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_color = beautiful.bg_urgent,
	bar_active_color = beautiful.blue,
	handle_width = 0,
	minimum = 0,
	maximum = 100,
	value = 0,
})

local previous_value = 0
local internal_update = false

media_slider:connect_signal("property::value", function(_, new_value)
	if internal_update and new_value ~= previous_value then
		playerctl:set_position(new_value)
		previous_value = new_value
	end
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec)
	internal_update = true
	previous_value = interval_sec
	media_slider.value = interval_sec
end)

awful.spawn.with_line_callback("playerctl -F metadata -f '{{mpris:length}}'", {
	stdout = function(line)
		if line == "" then
			local position = 100
			media_slider.maximum = position
		else
			local position = tonumber(line)
			if position ~= nil then
				media_slider.maximum = position / 1000000 or nil
			end
		end
	end,
})

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if album_path == "" then
		art:set_image(beautiful.no_song)
	else
		art:set_image(gears.surface.load_uncached(album_path))
	end
	title_widget:set_markup_silently(title)
	artist_widget:set_markup_silently(artist)
end)

playerctl:connect_signal("playback_status", function(_, playing, player_name)
	music_button:get_children_by_id("icon")[1].markup = playing and helpers.colorize_text("", "")
		or helpers.ui.colorizeText("", "")
end)

local music = wibox.widget({
	widget = wibox.container.background,
	forced_height = 192,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.stack,
			{
				widget = wibox.container.place,
				halign = "right",
				art,
			},
			{
				widget = wibox.container.background,
				bg = {
					type = "linear",
					from = { 0, 0 },
					to = { 460, 0 },
					stops = {
						{ 0.4, beautiful.bg_alt },
						{ 0.7, beautiful.bg_alt .. "CC" },
						{ 1, beautiful.bg_alt .. "00" },
					},
				},
			},
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{
					widget = wibox.container.rotate,
					direction = "east",
					{
						widget = wibox.container.background,
						forced_width = 10,
						forced_height = 6,
						media_slider,
					},
				},
				{
					layout = wibox.layout.flex.vertical,
					{
						layout = wibox.layout.fixed.vertical,
						spacing = 10,
						forced_width = 200,
						forced_height = 100,
						{
							widget = wibox.container.scroll.horizontal,
							step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
							speed = 50,
							title_widget,
						},
						artist_widget,
					},
					{
						widget = wibox.container.place,
						valign = "bottom",
						halign = "left",
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = 15,
							prev,
							music_button,
							next,
						},
					},
				},
			},
		},
	},
})

return music
