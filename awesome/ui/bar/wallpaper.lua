local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

-- Function to read wall list
local function read_wall_list(file_path)
	local wallpapers = {}
	for line in io.lines(file_path) do
		local wall_path = line:match("(.+)")
		if wall_path then
			table.insert(wallpapers, { path = wall_path })
		end
	end
	return wallpapers
end

local walls = read_wall_list(os.getenv("HOME") .. "/.config/awesome/launcher/walls.txt")

local index_start = 1
local entries_per_page = 18
local selected_item = 1

local wall_list_widget = wibox.widget({
	layout = wibox.layout.grid,
	homogeneous = true,
	forced_num_cols = 2,
	forced_num_rows = 9,
	vertical_spacing = dpi(-50),
	horizontal_spacing = dpi(25),
})

local function update_wall_list()
	wall_list_widget:reset()
	for i = index_start, math.min(index_start + entries_per_page - 1, #walls) do
		local wall_item = walls[i]
		if wall_item then
			local wallpaper_widget = wibox.widget({
				{
					image = wall_item.path,
					widget = wibox.widget.imagebox,
					resize = true,
					clipshape = gears.shape.rounded_rect,
					downscale = true,
					forced_width = dpi(185),
					forced_height = dpi(185),
				},
				widget = wibox.container.margin,
				margins = dpi(5),
			})

			wallpaper_widget:buttons(gears.table.join(awful.button({}, 1, function()
				awful.spawn.with_shell("~/.config/awesome/scripts/wallpaper.sh " .. wall_item.path)
				Leftbar.visible = false
			end)))

			wall_list_widget:add(wallpaper_widget)
		end
	end
end

local function ensure_visible()
	if selected_item < index_start then
		index_start = selected_item
	elseif selected_item >= index_start + entries_per_page then
		index_start = selected_item - entries_per_page + 1
	end
	update_wall_list()
end

local function select_next_item()
	if selected_item < #walls then
		selected_item = selected_item + 2
		ensure_visible()
	end
end

local function select_prev_item()
	if selected_item > 1 then
		selected_item = selected_item - 2
		ensure_visible()
	end
end

Leftbar = awful.popup({
	widget = {
		{
			{
				wall_list_widget,
				margins = dpi(10),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(8),
		widget = wibox.container.margin,
	},
	ontop = true,
	visible = false,
	y = dpi(45),
	type = "dock",
	width = dpi(500),
	maximum_width = dpi(500),
	minimum_width = dpi(500),
})

Leftbar:buttons(gears.table.join(awful.button({}, 4, select_prev_item), awful.button({}, 5, select_next_item)))

update_wall_list()

return Leftbar
