local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- calendar --

local styles = {}

styles.month = {
	bg_color = beautiful.bg,
}

styles.normal = {}

styles.focus = {
	fg_color = beautiful.bg,
	bg_color = beautiful.accent,
}

styles.weekday = {
	bg_color = beautiful.bg,
}

local function create_calendar_button(icon)
	local widget = wibox.widget({
		widget = wibox.container.background,
		{
			widget = wibox.widget.textbox,
			text = icon,
			font = beautiful.font .. " 20",
		},
	})
	return widget
end

local button_next = create_calendar_button("")
local button_back = create_calendar_button("")

local function decorate_cell(widget, flag, date)
	local cur_date = os.date("*t")
	if (cur_date.year ~= date.year or cur_date.month ~= date.month) and flag == "focus" then
		flag = "normal"
	end
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
	if flag == "header" then
		return wibox.widget({
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			fg = beautiful.fg,
			{
				layout = wibox.layout.align.horizontal,
				button_back,
				widget,
				button_next,
			},
		})
	end
	if flag == "normal" or flag == "focus" then
		widget.text = tostring(tonumber(widget.text))
		widget.align = "center"
	end

	-- Change bg color for weekends --

	local d = {
		year = date.year,
		month = (date.month or 1),
		day = (date.day or 1),
	}
	local weekday = tonumber(os.date("%w", os.time(d)))
	local default_fg = (weekday == 0 or weekday == 6) and beautiful.fg_alt or beautiful.fg

	local props = styles[flag] or {}

	local ret = wibox.widget({
		fg = props.fg_color or default_fg,
		bg = props.bg_color,
		widget = wibox.container.background,
		{
			margins = { left = 7, right = 7, top = 5, bottom = 5 },
			widget = wibox.container.margin,
			widget,
		},
	})
	return ret
end

local calendar = wibox.widget({
	date = os.date("*t"),
	font = beautiful.font,
	spacing = 10,
	fn_embed = decorate_cell,
	widget = wibox.widget.calendar.month,
})

local function change_mounth(number)
	local date = calendar:get_date()
	calendar:set_date(nil)
	date.month = date.month + number
	calendar:set_date(date)
end

calendar:buttons({
	awful.button({}, 4, function()
		change_mounth(1)
	end),
	awful.button({}, 5, function()
		change_mounth(-1)
	end),
})

button_back:buttons({
	awful.button({}, 1, function()
		change_mounth(-1)
	end),
})

button_next:buttons({
	awful.button({}, 1, function()
		change_mounth(1)
	end),
})

-- main window --

local main = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.bg,
	{
		widget = wibox.container.margin,
		margins = 10,
		calendar,
	},
})

local calendar_widget = awful.popup({
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 270,
	maximum_height = 330,
	minimum_width = 318,
	maximum_width = 318,
	placement = function(d)
		awful.placement.top_left(d, {
			honor_workarea = true,
			margins = beautiful.useless_gap * 2 + beautiful.border_width * 1,
		})
	end,
	widget = main,
})

-- summon functions --

awesome.connect_signal("open::calendar", function()
	awesome.emit_signal("bar::calendar")
	calendar:set_date(os.date("*t"))
	calendar_widget.visible = not calendar_widget.visible
end)

-- hide on click --

client.connect_signal("button::press", function()
	if calendar_widget.visible == true then
		awesome.emit_signal("open::calendar")
	end
end)

awful.mouse.append_global_mousebinding(awful.button({}, 1, function()
	if calendar_widget.visible == true then
		awesome.emit_signal("open::calendar")
	end
end))
