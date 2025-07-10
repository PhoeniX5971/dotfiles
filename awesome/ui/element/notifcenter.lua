local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")
local beautiful = require("beautiful")
local config = require("config")
local dpi = beautiful.xresources.apply_dpi

-- notification list --

local notifs_count = 0
awesome.emit_signal("notifs::count", notifs_count)

local label = wibox.widget({
	text = "Notifications",
	align = "center",
	widget = wibox.widget.textbox,
})

local notifs_clear = wibox.widget({
	markup = helpers.colorize_text("", beautiful.battery_red),
	font = "Symbols Nerd Font Mono Bold " .. 12 * config.dpi_multiplier,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
	_G.notif_center_reset_notifs_container()
	notifs_count = 0
	awesome.emit_signal("notifs::count", notifs_count)
end)))

local notifs_empty = wibox.widget({
	forced_height = dpi(900) * config.dpi_multiplier,
	widget = wibox.container.background,
	{
		layout = wibox.layout.flex.vertical,
		{
			markup = helpers.colorize_text("No notifications", beautiful.bg_urgent),
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
	},
})

local notifs_container = wibox.widget({
	forced_height = dpi(900) * config.dpi_multiplier,
	layout = require("overflow").vertical,
	scrollbar_enabled = false,
	spacing = 10,
	step = 80,
})

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
	notifs_container:reset(notifs_container)
	notifs_container:insert(1, notifs_empty)
	remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
	notifs_container:remove_widgets(box)

	if #notifs_container.children == 0 then
		notifs_container:insert(1, notifs_empty)
		remove_notifs_empty = true
	end
end

local create_notif = function(icon, n, width)
	local time = os.date("%H:%M:%S")

	local icon_widget = wibox.widget({
		widget = wibox.container.constraint,
		{
			widget = wibox.container.margin,
			margins = dpi(20) * config.dpi_multiplier,
			{
				widget = wibox.widget.imagebox,
				image = icon,
				clip_shape = gears.shape.circle,
				halign = "center",
				valign = "center",
			},
		},
	})

	local title_widget = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = 50,
		forced_width = dpi(200) * config.dpi_multiplier,
		{
			widget = wibox.widget.textbox,
			text = n.title,
			align = "left",
			forced_width = dpi(200) * config.dpi_multiplier,
		},
	})

	local time_widget = wibox.widget({
		widget = wibox.container.margin,
		margins = { right = dpi(4) * config.dpi_multiplier },
		{
			widget = wibox.widget.textbox,
			text = time,
			align = "right",
			valign = "bottom",
		},
	})

	local text_notif = wibox.widget({
		markup = n.message,
		align = "left",
		forced_width = dpi(165) * config.dpi_multiplier,
		widget = wibox.widget.textbox,
	})

	local box = wibox.widget({
		widget = wibox.container.background,
		forced_height = dpi(120) * config.dpi_multiplier,
		shape = helpers.rrect(dpi(6) * config.dpi_multiplier),
		bg = beautiful.bg_normal,
		{
			layout = wibox.layout.align.horizontal,
			icon_widget,
			{
				widget = wibox.container.margin,
				margins = dpi(10) * config.dpi_multiplier,
				{
					layout = wibox.layout.align.vertical,
					{
						layout = wibox.layout.fixed.vertical,
						expand = "none",
						spacing = dpi(10) * config.dpi_multiplier,
						{
							layout = wibox.layout.align.horizontal,
							title_widget,
							nil,
							time_widget,
						},
						text_notif,
					},
				},
			},
		},
	})

	box:buttons(gears.table.join(awful.button({}, 1, function()
		_G.notif_center_remove_notif(box)
		notifs_count = notifs_count - 1
		awesome.emit_signal("notifs::count", notifs_count)
	end)))

	return box
end

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
	if #notifs_container.children == 1 and remove_notifs_empty then
		notifs_container:reset(notifs_container)
		remove_notifs_empty = false
	end

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.notification_icon
	end

	notifs_container:insert(1, create_notif(appicon, n, width))
	notifs_count = notifs_count + 1
	awesome.emit_signal("notifs::count", notifs_count)
end)

local notifs_count_widget = wibox.widget.textbox()

awesome.connect_signal("notifs::count", function(count)
	if count == 0 then
		notifs_count_widget.text = ""
	else
		notifs_count_widget.text = "(" .. count .. ")"
	end
end)

local notifs = wibox.widget({
	spacing = dpi(10) * config.dpi_multiplier,
	layout = wibox.layout.fixed.vertical,
	{
		widget = wibox.container.margin,
		margins = dpi(10) * config.dpi_multiplier,
		{
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10) * config.dpi_multiplier,
				label,
				notifs_count_widget,
			},
			nil,
			notifs_clear,
		},
	},
	notifs_container,
})

-- main window --

local main = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.bg,
	{
		widget = wibox.container.margin,
		margins = dpi(10) * config.dpi_multiplier,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(10) * config.dpi_multiplier,
			notifs,
		},
	},
})

local notif_center = awful.popup({
	visible = false,
	ontop = true,
	shape = helpers.rrect(dpi(6) * config.dpi_multiplier),
	border_color = beautiful.border_color,
	minimum_height = dpi(900) * config.dpi_multiplier,
	maximum_height = dpi(900) * config.dpi_multiplier,
	minimum_width = dpi(590) * config.dpi_multiplier,
	maximum_width = dpi(590) * config.dpi_multiplier,
	placement = function(d)
		awful.placement.bottom_right(d, {
			honor_workarea = true,
			margins = beautiful.useless_gap * dpi(2) * config.dpi_multiplier
				+ beautiful.border_width * 1 * config.dpi_multiplier,
		})
	end,
	widget = main,
})

-- summon functions --

awesome.connect_signal("open::notif_center", function()
	awesome.emit_signal("bar::notif_center")
	notif_center.visible = not notif_center.visible
end)

-- hide on click --

client.connect_signal("button::press", function()
	if notif_center.visible == true then
		awesome.emit_signal("open::notif_center")
	end
end)

awful.mouse.append_global_mousebinding(awful.button({}, 1, function()
	if notif_center.visible == true then
		awesome.emit_signal("open::notif_center")
	end
end))
