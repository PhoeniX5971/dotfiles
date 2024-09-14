local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local user = require("user")
local rubato = require("modules.rubato")

screen.connect_signal("request::desktop_decoration", function(s)
	-- control --

	local control = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.background,
			id = "control",
			bg = beautiful.bg_alt,
			{
				widget = wibox.container.margin,
				margins = { right = 8, left = 8 },
				{
					widget = wibox.widget.textbox,
					text = "",
					halign = "center",
				},
			},
		},
	})

	awesome.connect_signal("bar::control", function()
		user.control = not user.control
		if not user.control then
			helpers.ui.transitionColor({
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					control:get_children_by_id("control")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		else
			helpers.ui.transitionColor({
				old = beautiful.bg_urgent,
				new = beautiful.bg_alt,
				transformer = function(col)
					control:get_children_by_id("control")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		end
	end)

	control:buttons({
		awful.button({}, 1, function()
			awesome.emit_signal("open::control")
		end),
	})

	-- keyboard layout --

	local mykeyboard = awful.widget.keyboardlayout()
	mykeyboard.widget.text = string.upper(mykeyboard.widget.text)
	mykeyboard.widget:connect_signal("widget::redraw_needed", function(wid)
		wid.text = string.upper(wid.text)
	end)

	local keyboard = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { left = -2, right = -3, top = 6, bottom = 6 },
			mykeyboard,
		},
	})

	-- tray --

	local tray_widget = wibox.widget({
		widget = wibox.container.margin,
		margins = { top = 4, bottom = 8 },
		{
			widget = wibox.widget.systray,
			horizontal = false,
			base_size = 24,
		},
	})

	local tray = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			layout = wibox.layout.fixed.horizontal,
			{
				widget = wibox.container.margin,
				margins = { left = 6, right = 6, bottom = 6, top = 6 },
				{
					widget = wibox.widget.textbox,
					id = "button",
					text = "",
					font = beautiful.font .. " 16",
					valign = "center",
				},
			},
			{
				widget = wibox.container.place,
				valign = "center",
				{
					layout = wibox.layout.fixed.horizontal,
					id = "tray",
				},
			},
		},
	})

	awesome.connect_signal("show::tray", function()
		if not user.tray then
			tray:get_children_by_id("button")[1].text = ""
			tray:get_children_by_id("tray")[1]:insert(1, tray_widget)
		else
			tray:get_children_by_id("button")[1].text = ""
			tray:get_children_by_id("tray")[1]:remove(1)
		end
		user.tray = not user.tray
	end)

	tray:buttons({
		awful.button({}, 1, function()
			awesome.emit_signal("show::tray")
		end),
	})

	-- clock --

	local time = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.background,
			id = "clock",
			bg = beautiful.bg_alt,
			{
				widget = wibox.container.margin,
				margins = { left = 6, right = 6 },
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 4,
					{
						widget = wibox.widget.textclock,
						format = "%H:%M:%S",
						refresh = 1,
						valign = "center",
					},
				},
			},
		},
	})

	awesome.connect_signal("bar::calendar", function()
		user.calendar = not user.calendar
		if not user.calendar then
			helpers.ui.transitionColor({
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					time:get_children_by_id("clock")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		else
			helpers.ui.transitionColor({
				old = beautiful.bg_urgent,
				new = beautiful.bg_alt,
				transformer = function(col)
					time:get_children_by_id("clock")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		end
	end)

	time:buttons({
		awful.button({}, 1, function()
			awesome.emit_signal("open::calendar")
		end),
	})

	-- taglist --

	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			id = "background_role",
			forced_height = 20,
			forced_width = 20,
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.animate = rubato.timed({
					duration = 0.3,
					easing = rubato.easing.linear,
					subscribed = function(h)
						self:get_children_by_id("background_role")[1].forced_height = h
					end,
				})
				self.update = function()
					if tag.selected then
						self.animate.target = 28
					elseif #tag:clients() > 0 then
						self.animate.target = 18
					end
				end
				self.update()
			end,
			update_callback = function(self)
				self.update()
			end,
		},
	})

	local taglist_widget = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = 10,
			taglist,
		},
	})

	-- battery --

	local bat = wibox.widget({
		layout = wibox.layout.stack,
		{
			widget = wibox.container.rotate,
			{
				widget = wibox.widget.progressbar,
				id = "progressbar",
				max_value = 100,
				forced_width = 85,
				background_color = beautiful.bg_urgent,
			},
		},
		{
			widget = wibox.widget.textbox,
			font = beautiful.font .. " 24",
			halign = "center",
			id = "icon",
			valign = "center",
		},
	})

	awesome.connect_signal("signal::battery", function(value, state)
		bat:get_children_by_id("progressbar")[1].value = value
		if value > 70 then
			bat:get_children_by_id("progressbar")[1].color = beautiful.green
		elseif value > 20 then
			bat:get_children_by_id("progressbar")[1].color = beautiful.yellow
		else
			bat:get_children_by_id("progressbar")[1].color = beautiful.red
		end
		if state == "Discharging" then
			bat:get_children_by_id("icon")[1].text = ""
		else
			bat:get_children_by_id("progressbar")[1].color = beautiful.green
			bat:get_children_by_id("icon")[1].markup = helpers.ui.colorizeText("󱐋", beautiful.bg)
		end
	end)

	-- dnd --

	local dnd_button = wibox.widget({
		widget = wibox.container.background,
		id = "dnd",
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { left = 8, right = 6, top = 8, bottom = 8 },
			{
				widget = wibox.widget.textbox,
				id = "icon",
				text = "",
				halign = "center",
			},
		},
	})

	awesome.connect_signal("signal::dnd", function()
		user.dnd = not user.dnd
		if not user.dnd then
			dnd_button:get_children_by_id("icon")[1].text = ""
			naughty.suspend()
		else
			dnd_button:get_children_by_id("icon")[1].text = ""
			naughty.resume()
		end
	end)

	awesome.connect_signal("bar::notif_center", function()
		user.notif_center = not user.notif_center
		if not user.notif_center then
			helpers.ui.transitionColor({
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					dnd_button:get_children_by_id("dnd")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		else
			helpers.ui.transitionColor({
				old = beautiful.bg_urgent,
				new = beautiful.bg_alt,
				transformer = function(col)
					dnd_button:get_children_by_id("dnd")[1]:set_bg(col)
				end,
				duration = 0.8,
			})
		end
	end)

	dnd_button:buttons({
		awful.button({}, 1, function()
			awesome.emit_signal("open::notif_center")
		end),
		awful.button({}, 3, function()
			awesome.emit_signal("signal::dnd")
		end),
	})
	-- bar --

	bar = awful.wibar({
		screen = s,
		position = "top",
		-- height = s.geometry.height + beautiful.border_width * 2,
		-- width = 48,
		height = 42,
		bg = beautiful.bg,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		margins = {
			top = -beautiful.border_width,
			bottom = -beautiful.border_width,
			left = -beautiful.border_width,
		},
		ontop = false,
		widget = {
			layout = wibox.layout.flex.horizontal,
			{
				widget = wibox.container.place,
				halign = "left",
				content_fill_horizontal = false,
				{
					widget = wibox.container.margin,
					margins = { left = 10, right = 10, top = 5, bottom = 5 },
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = 10,
						control,
						time,
						taglist_widget,
					},
				},
			},
			{
				widget = wibox.container.place,
				halign = "center",
				content_fill_horizontal = false,
				{
					widget = wibox.container.margin,
					margins = { left = 10, right = 10 },
					{
						layout = wibox.layout.fixed.horizontal,
					},
				},
			},
			{
				widget = wibox.container.place,
				halign = "right",
				content_fill_horizontal = false,
				{
					widget = wibox.container.margin,
					margins = { right = 10, left = 10, top = 6, bottom = 6 },
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = 10,
						tray,
						bat,
						keyboard,
						dnd_button,
					},
				},
			},
		},
	})
end)

awesome.connect_signal("hide::bar", function()
	bar.visible = not bar.visible
end)
