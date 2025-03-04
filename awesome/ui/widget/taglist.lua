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
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	-- Taglist widget template
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "text_role",
						align = "center",
						valign = "center",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.margin,
					margins = dpi(2), -- Adjust margins for better sizing
				},
				id = "background_role",
				widget = wibox.container.background,
				forced_width = dpi(35),
				forced_height = dpi(35),
			},
			shape = helpers.rrect(100), -- Apply circle shape here
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.update = function()
					if tag.selected then
						self.bg = beautiful.taglist_bg_focus
						self.fg = beautiful.taglist_fg_focus
					elseif #tag:clients() > 0 then
						self.bg = beautiful.taglist_bg_occupied or beautiful.bg_focus
						self.fg = beautiful.taglist_fg_occupied
					else
						self.bg = beautiful.taglist_bg_empty or beautiful.bg_focus
						self.fg = beautiful.taglist_fg_empty
					end
				end
				self.update()
				tag:connect_signal("property::selected", self.update)
				tag:connect_signal("property::urgent", self.update)
				tag:connect_signal("tagged", self.update)
				tag:connect_signal("untagged", self.update)
			end,
			update_callback = function(self)
				self.update()
			end,
		},
	})

	-- Outer container to create space around the taglist
	local taglist_widget = wibox.widget({
		{
			{
				taglist,
				margins = {
					left = 1,
					right = 1,
				},
				widget = wibox.container.margin,
			},
			bg = beautiful.bg_focus, -- Background color for the container
			shape = helpers.rrect(100), -- Round the container edges
			widget = wibox.container.background,
		},
		layout = wibox.layout.align.horizontal, -- Keeps the layout consistent
	})

	return taglist_widget
end

return get_taglist
