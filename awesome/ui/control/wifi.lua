local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local helpers = require("helpers")
local beautiful = require("beautiful")

local wifi = {}

local function hover_button(widget)
	local main_widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		fg = beautiful.fg,
		forced_width = 40,
		forced_height = 30,
		widget
	}
	main_widget:connect_signal("mouse::enter", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_alt,
			new = beautiful.bg_urgent,
			transformer = function(col)
				main_widget.bg = col
			end,
			duration = 0.8
		}
	end)
	main_widget:connect_signal("mouse::leave", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_urgent,
			new = beautiful.bg_alt,
			transformer = function(col)
				main_widget.bg = col
			end,
			duration = 0.8
		}
	end)
	return main_widget
end

-- widgets --

local reveal_button = hover_button({
	widget = wibox.widget.textbox,
	align = "center",
	text = "",
	font = beautiful.font .. " 14"
})

local refresh_button = hover_button({
	widget = wibox.widget.textbox,
	align = "center",
	text = "",
	font = beautiful.font .. " 13"
})

local massage = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.fg_alt,
	forced_width = 370,
	forced_height = 458,
	{
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center"
	}
}

local active_widget_container = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	forced_width = 370
}

local wifi_widget_container = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	forced_width = 370
}

local bottombar = wibox.widget {
	widget =  wibox.container.margin,
	margins = { right = 10, bottom = 10, top = 10 },
	{
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_width = 60,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.align.vertical,
				refresh_button,
				nil,
				reveal_button
			}
		}
	}
}

local main = wibox.widget {
	widget = wibox.container.background,
	{
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.background,
			forced_height = 408,
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					layout = wibox.layout.fixed.vertical,
					active_widget_container,
					wifi_widget_container
				}
			}
		},
		bottombar
	}
}

local wifi_applet = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_width = 450,
	maximum_width = 450,
	minimum_height = 478,
	maximum_height = 478,
	placement = function(d)
		awful.placement.centered(d, { honor_workarea = true })
	end,
	widget = main,
}


-- functions

function wifi:update_status()
	awful.spawn.easy_async_with_shell("nmcli g | sed 1d | awk '{print $3, $4}'", function(stdout)
		local hw, rd = stdout:match("(%w+)%s+(%w+)")
		if hw:match("enabled") and rd:match("enabled") then
			wifi.status = true
			awesome.emit_signal("wifi::status", wifi.status)
			wifi:get()
		elseif hw:match("missing") then
			wifi.status = false
			awesome.emit_signal("wifi::status", wifi.status)
			wifi_widget_container:add(massage)
			massage.widget.text = "Wifi hardware\nis missing"
			awful.spawn("nmcli radio wifi off")
		else
			wifi.status = false
			awesome.emit_signal("wifi::status", wifi.status)
			wifi_widget_container:add(massage)
			massage.widget.text = "Wifi disabled"
		end
	end)
end

function wifi:get()
	local wifi_list = {}
	local nmcli = "nmcli -t -f 'SSID, BSSID, SECURITY, ACTIVE' device wifi list"
	active_widget_container:add(massage)
	massage.widget.text = "Please wait"
	awful.spawn.easy_async_with_shell(nmcli, function(stdout)
		for line in stdout:gmatch("[^\n]+") do
			local ssid, bssid_raw, security, active = line:gsub([[\:]], [[\sep]]):match("(.*):(.*):(.*):(.*)")
			local bssid = string.gsub(bssid_raw, [[\sep]], ":")
			table.insert(wifi_list, { ssid = ssid, bssid = bssid, security = security, active = active })
			wifi:add_entries(wifi_list)
		end
	end)
end

function wifi:add_entries(list)
	wifi_widget_container:reset()
	active_widget_container:reset()
	for _, entry in ipairs(list) do
		local entry_info = wibox.widget {
			widget = wibox.widget.textbox
		}
		local wifi_entry = wibox.widget {
			widget = wibox.container.background,
			forced_height = 50,
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					layout = wibox.layout.align.horizontal,
					{
						widget = wibox.widget.textbox,
						text = entry.ssid
					},
					nil,
					entry_info
				}
			}
		}

		if entry.active:match("yes") then
			entry_info.text = ""
			active_widget_container:add(wifi_entry)
		elseif entry.active:match("no") then
			if entry.security:match("WPA") then
				entry_info.text = ""
			else
				entry_info.text = ""
			end
			wifi_entry.buttons = {
				awful.button({}, 1, function()
					wifi:connect(entry.ssid, entry.bssid, entry.security)
				end)
			}
			wifi_widget_container:add(wifi_entry)
		end
	end
end

function wifi:connect(ssid, bssid, security)
	local nmcli = "nmcli device wifi connect "

	if security:match("WPA") then
		awful.keygrabber.stop()
		wifi_widget_container:reset()
		active_widget_container:reset()
		wifi_widget_container:add(massage)
		awful.prompt.run {
			prompt = ssid .. "\n\nPassword: ",
			textbox = massage.widget,
			bg_cursor = beautiful.foreground,
			done_callback = function()
				wifi:refresh()
			end,
			exe_callback = function(input)
				awful.spawn.easy_async_with_shell(nmcli .. bssid .. " password " .. input, function(stdout, stderr)
					wifi.send_notification(stdout, stderr, ssid)
				end)
			end
		}
	else
		awful.spawn.easy_async_with_shell(nmcli .. bssid, function(stdout, stderr)
			wifi:send_notification(stdout, stderr, ssid)
			wifi:refresh()
		end)
	end
end

function wifi.send_notification(stdout, stderr, ssid)
	if stdout:match("successfully") then
		naughty.notification {
			title = "Wifi",
			text = "connect successfully to\n" .. ssid
		}
	elseif stderr:match("Error") then
		naughty.notification {
			urgency = "critical",
			title = "Wifi",
			text = "failed to connect\n" .. ssid
		}
	end
end

function wifi.refresh()
	wifi_widget_container:reset()
	active_widget_container:reset()
	wifi:update_status()
end



local function wifi_toggle()
	if wifi.status then
		awful.spawn.easy_async_with_shell("nmcli radio wifi off", function()
			wifi.refresh()
		end)
	else
		awful.spawn.easy_async_with_shell("nmcli radio wifi on", function()
			wifi.refresh()
		end)
	end
end

wifi_widget_container:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if ( #active_widget_container.children + #wifi_widget_container.children <= 9) then
			return
		end
		wifi_widget_container:insert(1, wifi_widget_container.children[#wifi_widget_container.children])
		wifi_widget_container:remove(#wifi_widget_container.children)
	end),

	awful.button({}, 5, nil, function()
		if ( #active_widget_container.children + #wifi_widget_container.children <= 9) then
			return
		end
		wifi_widget_container:insert(#wifi_widget_container.children + 1, wifi_widget_container.children[1])
		wifi_widget_container:remove(1)
	end)
))

reveal_button:buttons(gears.table.join(awful.button({}, 1, function()
	awesome.emit_signal("open::wifi_applet")
end)))

refresh_button:buttons(gears.table.join(awful.button({}, 1, function()
	wifi.refresh()
end)))

-- summon functions --

awesome.connect_signal("open::wifi_applet", function()
	wifi_applet.visible = not wifi_applet.visible
end)

-- hide on click --


client.connect_signal("button::press", function()
	wifi_applet.visible = false
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		wifi_applet.visible = false
	end)
)

wifi:update_status()
return main
