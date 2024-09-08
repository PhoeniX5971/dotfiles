local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("modules.bling")
local playerctl = bling.signal.playerctl.lib()
local helpers = require("helpers")
local user = require("user")
require("scripts.init")
local weather = require("ui.control.weather")
local rubato = require("modules.rubato")

screen.connect_signal("request::desktop_decoration", function(s)
	-- arccharts --

	local create_arcchart_widget = function(widget, signal, bg, fg, thickness, text, icon)
		local widget = wibox.widget({
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_width = 150,
			forced_height = 180,
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 10,
					{
						layout = wibox.layout.stack,
						{
							widget = wibox.container.margin,
							margins = 6,
							{
								widget = wibox.container.arcchart,
								id = "progressbar",
								max_value = 100,
								min_value = 0,
								thickness = thickness,
								bg = bg,
								colors = { fg },
							},
						},
						{
							widget = wibox.widget.textbox,
							id = "icon",
							font = beautiful.font .. " 20",
							text = icon,
							halign = "center",
							valign = "center",
						},
					},
					{
						layout = wibox.layout.flex.horizontal,
						{
							widget = wibox.widget.textbox,
							text = text,
						},
						{
							widget = wibox.container.place,
							halign = "right",
							{
								widget = wibox.widget.textbox,
								id = "text",
							},
						},
					},
				},
			},
		})

		local anim = rubato.timed({
			duration = 0.3,
			easing = rubato.easing.linear,
			subscribed = function(h)
				widget:get_children_by_id("progressbar")[1].value = h
			end,
		})

		awesome.connect_signal(signal, function(value)
			anim.target = value
			widget:get_children_by_id("text")[1].text = value .. "%"
		end)

		return widget
	end

	local resourses = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		create_arcchart_widget(cpu, "signal::cpu", beautiful.bg_urgent, beautiful.red, 15, "Cpu:", ""),
		create_arcchart_widget(ram, "signal::ram", beautiful.bg_urgent, beautiful.yellow, 15, "Ram:", ""),
		create_arcchart_widget(disk, "signal::disk", beautiful.bg_urgent, beautiful.blue, 15, "Disk:", ""),
	})

	-- progressbars --

	local create_progressbar_widget = function(color, width, icon)
		return wibox.widget({
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_height = 20,
			{
				layout = wibox.layout.fixed.horizontal,
				fill_space = true,
				spacing = 10,
				{
					widget = wibox.widget.textbox,
					id = "icon",
					text = icon,
					font = beautiful.font .. " 13",
					halign = "center",
				},
				{
					widget = wibox.container.background,
					forced_width = 36,
					{
						widget = wibox.widget.textbox,
						id = "text",
						halign = "center",
					},
				},
				{
					widget = wibox.widget.progressbar,
					id = "progressbar",
					max_value = 100,
					forced_width = width,
					background_color = beautiful.bg_urgent,
					color = color,
				},
			},
		})
	end

	local volume = create_progressbar_widget(beautiful.cyan, 370, "")

	volume:buttons({
		awful.button({}, 1, function()
			awful.spawn.with_shell("amixer -D pipewire sset Master toggle")
			update_value_of_volume()
		end),
		awful.button({}, 4, function()
			awful.spawn.with_shell("amixer -D pipewire sset Master 2%+")
			update_value_of_volume()
		end),
		awful.button({}, 5, function()
			awful.spawn.with_shell("amixer -D pipewire sset Master 2%-")
			update_value_of_volume()
		end),
	})

	local anim_volume = rubato.timed({
		duration = 0.3,
		easing = rubato.easing.linear,
		subscribed = function(h)
			volume:get_children_by_id("progressbar")[1].value = h
		end,
	})

	awesome.connect_signal("signal::volume", function(value, icon)
		anim_volume.target = value
		volume:get_children_by_id("text")[1].text = value
		volume:get_children_by_id("icon")[1].text = icon
	end)

	local bright = create_progressbar_widget(beautiful.blue, 370, "")

	local anim_bright = rubato.timed({
		duration = 0.3,
		easing = rubato.easing.linear,
		subscribed = function(h)
			bright:get_children_by_id("progressbar")[1].value = h
		end,
	})

	bright:buttons({
		awful.button({}, 4, function()
			awful.spawn.with_shell("brightnessctl s 5%+")
			update_value_of_bright()
		end),
		awful.button({}, 5, function()
			awful.spawn.with_shell("brightnessctl s 5%-")
			update_value_of_bright()
		end),
	})

	awesome.connect_signal("signal::bright", function(value, icon)
		anim_bright.target = value
		bright:get_children_by_id("text")[1].text = value
	end)

	local info = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_height = 80,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 20,
				volume,
				bright,
			},
		},
	})

	-- profile --

	local create_fetch_comp = function(icon, func)
		local widget = wibox.widget({
			widget = wibox.container.place,
			halign = "right",
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{
					widget = wibox.widget.textbox,
					id = "text",
					halign = "right",
				},
				{
					widget = wibox.widget.textbox,
					text = icon,
				},
			},
		})
		awful.spawn.easy_async_with_shell(func, function(stdout)
			widget:get_children_by_id("text")[1].text = stdout
		end)
		return widget
	end

	local fetch = wibox.widget({
		layout = wibox.layout.flex.vertical,
		forced_width = 314,
		spacing = 11,
		create_fetch_comp(
			"",
			[[ distro | grep "Name:" | awk '{sub(/^Name: /, ""); print}' | awk '{print $1 " " $2}' ]]
		),
		create_fetch_comp("", [[ uname -r ]]),
		create_fetch_comp("", [[ xbps-query -l | wc -l ]]),
		create_fetch_comp("", [[ echo Awesome WM ]]),
	})

	local profile_image = wibox.widget({
		widget = wibox.widget.imagebox,
		forced_width = 90,
		forced_height = 90,
		image = beautiful.profile_image,
	})

	local profile_name = wibox.widget.textbox()

	awful.spawn.easy_async_with_shell([[whoami | sed 's/.*/\u&/']], function(stdout)
		profile_name.text = "@" .. stdout
	end)

	local line = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.green,
		forced_width = beautiful.border_width * 3,
	})

	local profile = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_height = 140,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 10,
					profile_image,
					profile_name,
				},
				fetch,
				line,
			},
		},
	})

	-- toggles --

	local create_toggle_widget = function(bg, fg, icon, name, value, arroy_visible, arroy_signal)
		return wibox.widget({
			widget = wibox.container.background,
			forced_width = 230,
			forced_height = 80,
			bg = beautiful.bg_alt,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{
					widget = wibox.container.margin,
					left = 10,
					{
						widget = wibox.container.place,
						align = "center",
						{
							widget = wibox.container.background,
							id = "icon_container",
							bg = bg,
							fg = fg,
							{
								widget = wibox.container.margin,
								margins = 10,
								{
									widget = wibox.widget.textbox,
									id = "icon",
									text = icon,
									font = beautiful.font .. " 20",
									halign = "center",
								},
							},
						},
					},
				},
				{
					widget = wibox.container.place,
					halign = "center",
					{
						layout = wibox.layout.fixed.vertical,
						{
							widget = wibox.widget.textbox,
							text = name,
						},
						{
							widget = wibox.widget.textbox,
							id = "value",
							text = value,
						},
					},
				},
				{
					widget = wibox.widget.textbox,
					text = "",
					forced_width = 80,
					halign = "right",
					font = beautiful.font .. " 24",
					visible = arroy_visible,
					buttons = {
						awful.button({}, 1, arroy_signal),
					},
				},
			},
		})
	end

	local toggle_change = function(x, widget)
		if x == "off" then
			widget:get_children_by_id("value")[1].text = "Off"
			helpers.ui.transitionColor({
				old = beautiful.accent,
				new = beautiful.bg_urgent,
				transformer = function(col)
					widget:get_children_by_id("icon_container")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
			helpers.ui.transitionColor({
				old = beautiful.bg,
				new = beautiful.fg,
				transformer = function(col)
					widget:get_children_by_id("icon_container")[1]:set_fg(col)
				end,
				duration = 0.8,
			})
		else
			widget:get_children_by_id("value")[1].text = "On"
			helpers.ui.transitionColor({
				old = beautiful.bg_urgent,
				new = beautiful.accent,
				transformer = function(col)
					widget:get_children_by_id("icon_container")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
			helpers.ui.transitionColor({
				old = beautiful.fg,
				new = beautiful.bg,
				transformer = function(col)
					widget:get_children_by_id("icon_container")[1]:set_fg(col)
				end,
				duration = 0.8,
			})
		end
	end

	local wifi = create_toggle_widget(beautiful.accent, beautiful.bg, "", "Wifi", "On", true, function()
		awesome.emit_signal("open::wifi_applet")
	end)

	awesome.connect_signal("signal::wifi", function(value)
		if value == "disabled" then
			toggle_change("off", wifi)
		else
			toggle_change("on", wifi)
		end
	end)

	function wifi_button()
		awesome.connect_signal("signal::wifi", function(value)
			if value == "disabled" then
				toggle_change("on", wifi)
				awful.spawn.with_shell("nmcli radio wifi on")
			else
				toggle_change("off", wifi)
				awful.spawn.with_shell("nmcli radio wifi off")
			end
		end)
	end

	wifi:get_children_by_id("icon_container")[1]:buttons({
		awful.button({}, 1, function()
			wifi_button()
			update_value_of_wifi()
		end),
	})

	local micro = create_toggle_widget(beautiful.accent, beautiful.bg, "", "Microphone", "On", false)

	awesome.connect_signal("signal::capture", function(value)
		if value == "off" then
			toggle_change("off", micro)
		else
			toggle_change("on", micro)
		end
	end)

	micro:get_children_by_id("icon_container")[1]:buttons({
		awful.button({}, 1, function()
			awful.spawn.with_shell("amixer -D pipewire sset Capture toggle")
			updateVolumeSignals()
		end),
	})

	local float = create_toggle_widget(beautiful.accent, beautiful.bg, "", "Floating", "On", false)
	toggle_change("off", float)

	float:get_children_by_id("icon_container")[1]:buttons({
		awful.button({}, 1, function()
			user.float_value = not user.float_value
			local tags = awful.screen.focused().tags
			if not user.float_value then
				toggle_change("off", float)
				for _, tag in ipairs(tags) do
					awful.layout.set(awful.layout.suit.tile, tag)
				end
			else
				toggle_change("on", float)
				for _, tag in ipairs(tags) do
					awful.layout.set(awful.layout.suit.floating, tag)
				end
			end
		end),
	})

	local opacity = create_toggle_widget(beautiful.accent, beautiful.bg, "", "Opacity", "On", false)

	opacity:get_children_by_id("icon_container")[1]:buttons({
		awful.button({}, 1, function()
			user.opacity_value = not user.opacity_value
			if not user.opacity_value then
				toggle_change("off", opacity)
				awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --no-opacity")
			else
				toggle_change("on", opacity)
				awful.spawn.with_shell("$HOME/.config/awesome/other/picom/launch.sh --opacity")
			end
		end),
	})

	local toggles = wibox.widget({
		layout = wibox.layout.grid,
		spacing = 10,
		forced_num_cols = 2,
		wifi,
		micro,
		float,
		opacity,
	})

	-- music player --

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
		music_button:get_children_by_id("icon")[1].markup = playing and helpers.ui.colorizeText("", "")
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

	-- main window --

	local main = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				profile,
				resourses,
				info,
				toggles,
				weather,
				music,
			},
		},
	})

	local control = awful.popup({
		screen = s,
		visible = false,
		ontop = true,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		minimum_height = s.geometry.height,
		minimum_width = 490,
		maximum_width = 490,
		placement = function(d)
			awful.placement.bottom_right(d, {
				margins = {
					top = -beautiful.border_width,
					bottom = -beautiful.border_width,
					right = -beautiful.border_width,
				},
			})
		end,
		widget = main,
	})

	-- summon functions --

	awesome.connect_signal("open::control", function()
		awesome.emit_signal("bar::control")
		control.visible = not control.visible
	end)

	-- hide on click --

	client.connect_signal("button::press", function()
		if control.visible == true then
			awesome.emit_signal("open::control")
		end
	end)

	awful.mouse.append_global_mousebinding(awful.button({}, 1, function()
		if control.visible == true then
			awesome.emit_signal("open::control")
		end
	end))
end)
