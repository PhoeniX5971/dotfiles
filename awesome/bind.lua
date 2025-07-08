local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local volume_osd = require("ui.element.osd.volume")
local brightness_osd = require("ui.element.osd.brightness")

-- Mouse
client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

-- General keybinds
awful.keyboard.append_global_keybindings({
	-- Awesome keybinds
	awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show keybinds", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey }, "Return", function()
		awful.spawn.with_shell(terminal)
	end, { description = "run terminal", group = "awesome" }),
	awful.key({ modkey }, "e", function()
		awful.spawn("nautilus")
	end, { description = "File Manager", group = "awesome" }),
	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "Screen Shot", group = "awesome" }),
	awful.key({ modkey }, "b", function()
		awful.spawn("brave")
	end, { description = "open browser", group = "awesome" }),
	awful.key({ modkey }, "d", function()
		awful.spawn("rofi -show drun")
	end, { description = "rofi launcher", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "d", function()
		awful.spawn.with_shell("bash ~/.config/rofi/bin/runner")
	end, { description = "rofi runner", group = "awesome" }),

	--Media keybinds
	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next")
	end),
	awful.key({}, "XF86AudioPause", function()
		awful.util.spawn("playerctl pause")
	end),
	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.easy_async_with_shell("pamixer --decrease 5 && sleep 0.05", function()
			volume_osd.update()
		end)
	end, { description = "lower volume", group = "media" }),

	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.easy_async_with_shell("pamixer --increase 5 && sleep 0.05", function()
			volume_osd.update()
		end)
	end, { description = "raise volume", group = "media" }),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn.easy_async_with_shell("pamixer -t && sleep 0.05", function()
			volume_osd.update()
		end)
	end, { description = "toggle mute", group = "media" }),

	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn.easy_async_with_shell("brightnessctl set +5% && sleep 0.05", function()
			brightness_osd.update()
		end)
	end, { description = "increase brightness", group = "media" }),

	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn.easy_async_with_shell("brightnessctl set 5%- && sleep 0.05", function()
			brightness_osd.update()
		end)
	end, { description = "decrease brightness", group = "media" }),

	awful.key({ modkey }, "F2", function()
		awesome.emit_signal("open::control")
	end, { description = "toggle control center", group = "custom" }),

	-- Tag keybinds
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, "Shift" },
		keygroup = "numrow",
		description = "move focused client to tag and follow",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
					tag:view_only()
				end
			end
		end,
	}),
})

-- Client keybinds
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "c", function(c)
			awful.placement.centered(c, { honor_workarea = true })
		end, { description = "center window", group = "client" }),
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),
		awful.key({ modkey }, "s", function(c)
			c.floating = not c.floating
			c:raise()
		end, { description = "toggle floating", group = "client" }),
		awful.key({ modkey }, "n", function(c)
			client.focus.minimized = true
		end, { description = "minimize", group = "client" }),
		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			if c then
				c:activate({ raise = true, context = "key.unminimize" })
			end
		end, { description = "restore minimized", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "toggle maximize", group = "client" }),
		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),

		-- Client Manipulation

		-- Move client to direction

		awful.key({ modkey, "Shift" }, "h", function()
			awful.client.swap.bydirection("left")
		end, { description = "swap client left", group = "client" }),

		awful.key({ modkey, "Shift" }, "l", function()
			awful.client.swap.bydirection("right")
		end, { description = "swap client right", group = "client" }),

		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.bydirection("up")
		end, { description = "swap client up", group = "client" }),

		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.bydirection("down")
		end, { description = "swap client down", group = "client" }),

		-- Navigate through clients

		awful.key({ modkey }, "h", function()
			awful.client.focus.bydirection("left")
		end, { description = "focus left", group = "client" }),

		awful.key({ modkey }, "l", function()
			awful.client.focus.bydirection("right")
		end, { description = "focus right", group = "client" }),

		awful.key({ modkey }, "k", function()
			awful.client.focus.bydirection("up")
		end, { description = "focus up", group = "client" }),

		awful.key({ modkey }, "j", function()
			awful.client.focus.bydirection("down")
		end, { description = "focus down", group = "client" }),

		-- Resize client

		-- Increase master width (expand master area)
		awful.key({ modkey, "Control" }, "l", function()
			awful.tag.incmwfact(0.05)
		end, { description = "increase master width", group = "layout" }),

		-- Decrease master width (shrink master area)
		awful.key({ modkey, "Control" }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, { description = "decrease master width", group = "layout" }),

		-- Increase client height in stack
		awful.key({ modkey, "Control" }, "j", function()
			awful.client.incwfact(0.05)
		end, { description = "increase client height", group = "layout" }),

		-- Decrease client height in stack
		awful.key({ modkey, "Control" }, "k", function()
			awful.client.incwfact(-0.05)
		end, { description = "decrease client height", group = "layout" }),

		awful.key({ modkey }, "Tab", function()
			awful.layout.inc(1)
		end, { description = "select next layout", group = "layout" }),

		awful.key({ modkey, "Shift" }, "Tab", function()
			awful.layout.inc(-1)
		end, { description = "select previous layout", group = "layout" }),
	})
end)
