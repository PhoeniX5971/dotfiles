local wibox = require("wibox")
local awful = require("awful")
local helpers = require("helpers")
local beautiful = require "beautiful"

local icon_map = {
	["01d"] = "",
	["02d"] = "",
	["03d"] = "",
	["04d"] = "",
	["09d"] = "",
	["10d"] = "",
	["11d"] = "",
	["13d"] = "",
	["50d"] = "",
	["01n"] = "",
	["02n"] = "",
	["03n"] = "",
	["04n"] = "",
	["09n"] = "",
	["10n"] = "",
	["11n"] = "",
	["13n"] = "",
	["50n"] = ""
}

local helpers_split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end


local createWeatherProg = function()

	local widget = wibox.widget {
		spacing = 6,
		layout = wibox.layout.fixed.vertical,
		{
			id = "time",
			halign = "center",
			widget = wibox.widget.textbox,
		},
		{
			id = "icon",
			font = beautiful.font.. " 22",
			halign = "center",
			widget = wibox.widget.textbox
		},
		{
			id = "temp",
			halign = "center",
			widget = wibox.widget.textbox
		},
	}

	widget.update = function(out, i)
		local hour = out.hourly[i]
		widget:get_children_by_id("temp")[1].markup = helpers.ui.colorizeText(math.floor(hour.temp) .. "°C", beautiful.fg)
		widget:get_children_by_id("icon")[1].text = icon_map[hour.weather[1].icon]
		widget:get_children_by_id("time")[1].text = os.date("%Hh", tonumber(hour.dt))
	end

  return widget
end

local hour1 = createWeatherProg()
local hour2 = createWeatherProg()
local hour3 = createWeatherProg()
local hour4 = createWeatherProg()
local hour5 = createWeatherProg()
local hour6 = createWeatherProg()
local hour7 = createWeatherProg()
local hour8 = createWeatherProg()
local hour9 = createWeatherProg()

local hourList = { hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8, hour9}

local dayWeather = function()

	local widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 6,
		forced_width = 120,
		{
			id = "day",
			halign = "center",
			widget = wibox.widget.textbox,
		},
		{
			id = "icon",
			font = beautiful.font.. " 22",
			halign = "center",
			widget = wibox.widget.textbox
		},
		{
			widget = wibox.container.place,
			halign = "center",
			{
				spacing = 4,
				layout = wibox.layout.fixed.horizontal,
				{
					id = "max",
					halign = "center",
					widget = wibox.widget.textbox,
				},
				{
					halign = "center",
					markup = helpers.ui.colorizeText("/", beautiful.bg_urgent),
					widget = wibox.widget.textbox,
				},
				{
					id = "min",
					halign = "center",
					widget = wibox.widget.textbox,
				},
			}
		}
	}

	widget.update = function(out, i)
		local day = out.daily[i]
		widget:get_children_by_id("icon")[1].text = icon_map[day.weather[1].icon]
		widget:get_children_by_id("day")[1].text = os.date("%a", tonumber(day.dt))
		local getTemp = function(temp)
			local sp = helpers_split(temp, ".")[1]
			return sp
		end
		widget:get_children_by_id("min")[1].markup = getTemp(helpers.ui.colorizeText(math.floor(day.temp.night) .. "°C", beautiful.fg))
		widget:get_children_by_id("max")[1].markup = getTemp(helpers.ui.colorizeText(math.floor(day.temp.day) .. "°C", beautiful.fg))
	end
	return widget

end

local day1 = dayWeather()
local day2 = dayWeather()
local day3 = dayWeather()
local day4 = dayWeather()
local day5 = dayWeather()
local day6 = dayWeather()

local daylist = { day1, day2, day3, day4, day5, day6 }


local function create_button(id, text)
	return wibox.widget {
		widget = wibox.container.background,
		forced_width = 220,
		id = id,
		forced_height = 36,
		{
			widget = wibox.container.margin,
			margins = 6,
			{
				widget = wibox.widget.textbox,
				halign = "center",
				text = text,
			}
		}
	}
end

local hours_button = create_button("hours_button", "Hours")
local days_button = create_button("days_button", "Days")

local days_layout = wibox.widget {
	layout = require("modules.overflow").horizontal,
	forced_width = 450,
	spacing = 10,
	step = 50,
	scrollbar_enabled = false,
	visible = false,
	day1,
	day2,
	day3,
	day4,
	day5,
	day6,
}

local hours_layout = wibox.widget {
	layout = require("modules.overflow").horizontal,
	forced_width = 450,
	step = 70,
	scrollbar_enabled = false,
	visible = true,
	spacing = 26,
	hour1,
	hour2,
	hour3,
	hour4,
	hour5,
	hour6,
	hour7,
	hour8,
	hour9,
}

local widget = wibox.widget {
	widget = wibox.container.background,
	forced_height = 248,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			{
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					{
						widget = wibox.container.margin,
						{
							id = "weathericon",
							forced_width = 70,
							forced_height = 70,
							halign = "center",
							font = beautiful.font.. " 36",
							widget = wibox.widget.textbox
						},
					}
				},
				{
					spacing = 4,
					layout = wibox.layout.fixed.vertical,
					{
						id = "temp",
						halign = "right",
						font = beautiful.font.. " 18",
						widget = wibox.widget.textbox,
						markup = helpers.ui.colorizeText("Hello", beautiful.fg)
					},
					{
						id = "desc",
						halign = "right",
						widget = wibox.widget.textbox,
						markup = helpers.ui.colorizeText("Hello", beautiful.fg)
					},
				},
			},
			{
				widget = wibox.container.place,
				halign = "center",
				{
					layout = wibox.layout.fixed.horizontal,
					forced_height = 100,
					hours_layout,
					days_layout,
				}
			},
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				hours_button,
				days_button,
			}
		}
	}
}

awesome.connect_signal("connect::weather", function(out)
	widget:get_children_by_id("weathericon")[1].text = out.image
	widget:get_children_by_id("desc")[1].markup = helpers.ui.colorizeText(
		string.lower(out.desc):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end), 
		beautiful.fg
	)
	widget:get_children_by_id("temp")[1].markup = helpers.ui.colorizeText(out.temp .. "°C", beautiful.fg)
	-- widget:get_children_by_id("feels")[1].markup = "Feels like " .. out.feelsLike .. "°C"
	--widget:get_children_by_id("humid")[1].markup = "Humidity: " .. out.humidity .. "%"
	for i, j in ipairs(hourList) do
		j.update(out, i)
	end
	for i, j in ipairs(daylist) do
    j.update(out, i)
  end
end)

hours_button:set_bg(beautiful.bg_urgent)

days_button:buttons {
	awful.button({}, 1, function()
		if not days_layout.visible then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					days_button:set_bg(col)
				end,
				duration = 0.8
			}
			days_layout.visible = true
			helpers.ui.transitionColor {
				old = beautiful.bg_urgent,
				new = beautiful.bg_alt,
				transformer = function(col)
					hours_button:set_bg(col)
				end,
				duration = 0.8
			}
			hours_layout.visible = false
		end
	end)
}

hours_button:buttons {
	awful.button({}, 1, function()
		if not hours_layout.visible then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					hours_button:set_bg(col)
				end,
				duration = 0.8
			}
			hours_layout.visible = true
			helpers.ui.transitionColor {
				old = beautiful.bg_urgent,
				new = beautiful.bg_alt,
				transformer = function(col)
					days_button:set_bg(col)
				end,
				duration = 0.8
			}
			days_layout.visible = false
		end
	end)
}

return widget
