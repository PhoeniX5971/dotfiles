local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

-- default modkey
local modkey = "Mod4"

local get_taglist = function(s)
	-- Buttons
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function()
			awful.tag.viewnext(s)
		end),
		awful.button({}, 5, function()
			awful.tag.viewprev(s)
		end)
	)

	-- Taglist widget template
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			layout = wibox.layout.fixed.vertical, -- Vertical layout
		},
		widget_template = {
			{
				{
					{
						id = "icon_role",
						align = "center",
						valign = "center",
						font = beautiful.icon_font or "DF Mono",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.margin,
					margins = dpi(6),
				},
				id = "background_role",
				widget = wibox.container.background,
				forced_width = dpi(40),
				forced_height = dpi(40),
			},
			widget = wibox.container.background,
			create_callback = function(self, tag, _, _)
				local icon_widget = self:get_children_by_id("icon_role")[1]

				self.update = function()
					if tag.selected then
						icon_widget.text = "" -- Focused
						self.bg = beautiful.bg_focus
						self.fg = beautiful.fg or "#eff7ff"
					elseif #tag:clients() > 0 then
						icon_widget.text = "" -- Occupied
						self.bg = beautiful.bg_focus or "#262b4b"
						self.fg = beautiful.fg_alt or "#91b5d1"
					else
						icon_widget.text = "" -- Empty
						self.bg = beautiful.bg_focus
						self.fg = beautiful.fg_alt or "#91b5d1"
					end
				end

				self.update()
				tag:connect_signal("property::selected", self.update)
				tag:connect_signal("property::urgent", self.update)
				tag:connect_signal("tagged", self.update)
				tag:connect_signal("untagged", self.update)
			end,
			update_callback = function(self, tag)
				self.update()
			end,
		},
	})

	-- Outer container for styling
	local taglist_widget = wibox.widget({
		{
			taglist,
			margins = dpi(4),
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_focus,
		shape = helpers.rrect(6), -- Slight rounded edges
		widget = wibox.container.background,
	})

	return taglist_widget
end

return get_taglist
