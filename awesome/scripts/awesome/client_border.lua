local helpers = require("helpers")
local beautiful = require("beautiful")

client.connect_signal("focus", function(c)
	helpers.ui.transitionColor {
		old = beautiful.border_color_normal,
		new = beautiful.border_color_active,
		transformer = function(col)
			local valid = pcall(function() return c.valid end) and c.valid
			if not valid then return end
			c.border_color = col
		end,
		duration = 0.8
	}
end)

client.connect_signal("unfocus", function(c)
	helpers.ui.transitionColor {
		old = beautiful.border_color_active,
		new = beautiful.border_color_normal,
		transformer = function(col)
			local valid = pcall(function() return c.valid end) and c.valid
			if not valid then return end
			c.border_color = col
		end,
		duration = 0.8
	}
end)
