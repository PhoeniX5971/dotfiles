local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")
local config = require("config")

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
		layout = (config.placement == "left" or config.placement == "right") and wibox.layout.fixed.vertical
			or wibox.layout.fixed.horizontal,
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
						-- If the tag is selected (focused)
						icon_widget.text = "" -- Focused
						self.bg = beautiful.taglist_bg_focus -- Transparent background for focused
						self.fg = beautiful.taglist_fg_focus -- Foreground color for focused
					elseif #tag:clients() > 0 then
						-- If the tag has clients (occupied)
						icon_widget.text = "" -- Occupied
						self.bg = beautiful.taglist_bg_occupied -- Transparent background for occupied
						self.fg = beautiful.taglist_fg_occupied -- Foreground color for occupied
					else
						-- If the tag is empty
						icon_widget.text = "" -- Empty
						self.bg = beautiful.taglist_bg_empty -- Transparent background for empty
						self.fg = beautiful.taglist_fg_empty -- Foreground color for empty
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
