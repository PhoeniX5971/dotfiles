local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local pampath = require("gears").filesystem.get_configuration_dir() .. "liblua_pam.so"
local pam = require("liblua_pam")

screen.connect_signal("request::desktop_decoration", function(s)

-- authentication --

awful.spawn.easy_async_with_shell("stat "..pampath.." >/dev/null 2>&1", function (_, _, _, exitcode)
		authenticate = function(password)
			return pam.auth_current_user(password)
		end
end)

-- variables --

local characters_entered = 0

-- widgets --

local header = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			widget = wibox.widget.imagebox,
			image = beautiful.profile_image,
			forced_width = 140,
			forced_height = 140,
		},
		{
			widget = wibox.widget.textbox,
			halign = "center",
			id = "name",
		}
	}
}

awful.spawn.easy_async_with_shell([[whoami | sed 's/.*/\u&/']], function(stdout)
	header:get_children_by_id("name")[1].text = "@"..stdout
end)

local time = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = 20,
		{
			widget = wibox.widget.textclock,
			font = beautiful.font.. " 38",
			format = "%H",
		},
		{
			widget = wibox.container.margin,
			top = 20,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				helpers.ui.create_point(beautiful.green, 10),
				helpers.ui.create_point(beautiful.yellow, 10),
				helpers.ui.create_point(beautiful.red, 10),
			},
		},
		{
			widget = wibox.widget.textclock,
			font = beautiful.font.. " 38",
			format = "%M",
		}
	}
}

local prompt = wibox.widget {
	widget = wibox.widget.textbox,
	markup = "enter password...",
	align = "center",
}

local main = wibox {
	width = s.geometry.width,
	height = s.geometry.height,
	bg = beautiful.bg,
	ontop = true,
	visible = false,
}

main:setup {
	layout = wibox.layout.stack,
	{
		widget = wibox.container.place,
		valign = "top",
		{
			widget = wibox.container.margin,
			top = 40,
			time,
		}
	},
	{
		widget = wibox.container.place,
		valign = "center",
		{
			layout = wibox.layout.fixed.vertical,
			header,
			{
				widget = wibox.container.background,
				bg = beautiful.bg_alt,
				{
					widget = wibox.container.margin,
					margins = 16,
					{
						widget = wibox.container.background,
						forced_width = 240,
						prompt,
					}
				}
			}
		}
	}
}


-- Reset

local function reset()
	characters_entered = 0;
	prompt.markup = "enter password..."
end

-- Fail

local function fail()
	characters_entered = 0;
	prompt.markup = "try again..."
end

-- Input

local function grabpassword()
	awful.prompt.run {
		hooks = {
			{{ }, "Escape", function(_)
					reset()
					grabpassword()
				end
			}
		},
		keypressed_callback  = function(_, key)
			if #key == 1 then
				characters_entered = characters_entered + 1
				prompt.markup = helpers.ui.colorizeText(string.rep("*", characters_entered), "")
			elseif key == "BackSpace" then
				if characters_entered > 1 then
					characters_entered = characters_entered - 1
					prompt.markup = helpers.ui.colorizeText(string.rep("*", characters_entered), "")
				else
					characters_entered = 0
					prompt.markup = "enter password..."
				end
			end
		end,
		exe_callback = function(input)
			if authenticate(input) then
				reset()
				main.visible = false
			else
				fail()
				grabpassword()
			end
		end,
		textbox = wibox.widget.textbox()
	}
end

-- Lock --

function lockscreen()
	main.visible = true
	grabpassword()
end

end)
