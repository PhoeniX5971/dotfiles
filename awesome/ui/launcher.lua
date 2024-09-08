local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local dir = "~/.disk/Books/'10 класс'/"
local rubato = require("modules.rubato")

local prompt = wibox.widget.textbox()

local entries_container = wibox.widget({
	homogeneous = false,
	expand = false,
	spacing = 12,
	forced_width = 330,
	forced_num_cols = 1,
	layout = wibox.layout.grid,
})

local modes = {
	{ name = nil, icon = "", index = 1 },
	{ name = "clipboard", icon = "", index = 2 },
	{ name = "books", icon = "", index = 3 },
	{ name = "themes", icon = "", index = 4 },
	{ name = "clients", icon = "", index = 5 },
}

local modes_container = wibox.widget({
	homogeneous = false,
	expand = false,
	forced_num_cols = 1,
	spacing = 10,
	layout = wibox.layout.grid,
})

local function mode_change(index)
	entries_container:reset()
	modes_container:reset()
	awful.keygrabber.stop()
	open(modes[index].name)
end

function add_modes()
	modes_container:reset()
	for i, mode in ipairs(modes) do
		local mode_widget = wibox.widget({
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_width = 40,
			forced_height = 40,
			buttons = {
				awful.button({}, 1, function()
					if index_mode ~= i then
						mode_change(mode.index)
					end
				end),
				awful.button({}, 4, function()
					if index_mode > 1 then
						index_mode = index_mode - 1
						if index_mode >= 1 then
							mode_change(index_mode)
						end
					end
				end),
				awful.button({}, 5, function()
					if index_mode < 5 then
						index_mode = index_mode + 1
						if index_mode <= 5 then
							mode_change(index_mode)
						end
					end
				end),
			},
			{
				widget = wibox.widget.textbox,
				fg = beautiful.fg,
				align = "center",
				font = beautiful.font .. " 14",
				markup = mode.icon,
			},
		})

		modes_container:add(mode_widget)
		if i == index_mode then
			helpers.ui.transitionColor({
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					mode_widget.bg = col
				end,
				duration = 0.8,
			})
		end
	end
end

local main = wibox.widget({
	widget = wibox.container.margin,
	margins = 10,
	{
		layout = wibox.layout.fixed.horizontal,
		forced_width = 390,
		spacing = 10,
		{
			layout = wibox.layout.stack,
			{
				widget = wibox.widget.imagebox,
				id = "image",
			},
			{
				widget = wibox.container.background,
				bg = {
					type = "linear",
					from = { 0, 0 },
					to = { 0, 478 },
					stops = { { 0.2, beautiful.bg_alt .. "4D" }, { 0.85, beautiful.bg } },
				},
			},
			{
				widget = wibox.container.place,
				valign = "bottom",
				halign = "left",
				{
					widget = wibox.container.background,
					bg = beautiful.bg_alt,
					forced_height = 56,
					forced_width = 374,
					{
						widget = wibox.container.margin,
						margins = { left = 10, right = 10 },
						prompt,
					},
				},
			},
		},
		{
			widget = wibox.container.background,
			forced_width = 330,
			entries_container,
		},
		{
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_width = 60,
			{
				widget = wibox.container.margin,
				margins = 10,
				modes_container,
			},
		},
	},
})

local launcher = awful.popup({
	minimum_width = 800,
	maximum_width = 800,
	minimum_height = 478,
	maximum_height = 478,
	bg = beautiful.bg,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	ontop = true,
	visible = false,
	placement = function(d)
		awful.placement.centered(d, { honor_workarea = true })
	end,
	widget = main,
})

-- Functions --
local function next()
	if index_entry ~= #filtered then
		index_entry = index_entry + 1
		if index_entry > index_start + 6 then
			index_start = index_start + 1
		end
	end
end

local function back()
	if index_entry ~= 1 then
		index_entry = index_entry - 1
		if index_entry < index_start then
			index_start = index_start - 1
		end
	end
end

local global_mode = nil

function gen(mode)
	local list = {
		["books"] = io.popen("ls " .. dir):lines(),
		["clipboard"] = io.popen(user.bins.greenclip .. " print"):lines(),
		["themes"] = io.popen("ls .config/awesome/theme/colors/ | cut -f 1 -d '.'"):lines(),
	}
	local entries = {}
	if mode == nil then
		for _, entry in ipairs(Gio.AppInfo.get_all()) do
			if entry:should_show() then
				local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
				table.insert(entries, { name = name, appinfo = entry })
			end
		end
	elseif mode == "clients" then
		for _, c in ipairs(client.get()) do
			table.insert(entries, { name = c.name, client = c, max = c.maximized, min = c.minimized })
		end
	else
		for entry in list[mode] do
			local open_command = {
				["clipboard"] = "echo " .. "'" .. entry .. "'" .. " | xclip -r -sel clipboard",
				["books"] = "cd " .. dir .. " && zathura " .. entry,
				["themes"] = "python3 ~/Code/Python/scripts/theme_switcher.py " .. entry,
			}
			table.insert(entries, { name = entry, appinfo = open_command[mode] })
		end
	end
	return entries
end

function filter(cmd)
	filtered = {}
	regfiltered = {}
	local clear_input = cmd:gsub("[%(%)%[%]]", "")

	-- Filter entries
	for _, entry in ipairs(unfiltered) do
		if entry.name:lower():sub(1, clear_input:len()) == cmd:lower() then
			table.insert(filtered, entry)
		elseif entry.name:lower():match(clear_input:lower()) then
			table.insert(regfiltered, entry)
		end
	end

	-- Sort entries
	if global_mode ~= "clipboard" then
		table.sort(filtered, function(a, b)
			return a.name:lower() < b.name:lower()
		end)
	end
	table.sort(regfiltered, function(a, b)
		return a.name:lower() < b.name:lower()
	end)

	-- Merge entries
	for i = 1, #regfiltered do
		filtered[#filtered + 1] = regfiltered[i]
	end

	-- Clear entries
	entries_container:reset()

	-- Add filtered entries
	for i, entry in ipairs(filtered) do
		local entry_image = wibox.widget({
			widget = wibox.widget.imagebox,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			opacity = 0.5,
			forced_width = 350,
			forced_height = 55,
		})

		local themes_line = wibox.widget({
			widget = wibox.container.margin,
			right = -beautiful.border_width * 2,
			{
				widget = wibox.container.background,
				forced_width = beautiful.border_width * 2,
				id = "bg",
			},
		})

		local entry_widget = wibox.widget({
			widget = wibox.container.background,
			forced_height = 55,
			forced_width = 350,
			buttons = {
				-- add left double click to launch (first click to navigate entry, second to run entry)
				awful.button({}, 1, function()
					if index_entry == i then
						if global_mode == nil then
							filtered[index_entry].appinfo:launch()
						elseif global_mode == "clients" then
							awful.client.jumpto(filtered[index_entry].client)
						else
							awful.spawn.with_shell(filtered[index_entry].appinfo)
						end
						awful.keygrabber.stop()
						launcher.visible = false
					else
						index_entry = i
						filter("")
					end
				end),
				-- add mouse scroll
				awful.button({}, 4, function()
					back()
					filter("")
				end),
				awful.button({}, 5, function()
					next()
					filter("")
				end),
			},
			{
				layout = wibox.layout.fixed.horizontal,
				id = "entry_layout",
				{
					margins = 10,
					id = "margin",
					widget = wibox.container.margin,
					{
						layout = wibox.layout.stack,
						id = "stack",
						{
							text = entry.name,
							id = "text",
							widget = wibox.widget.textbox,
						},
					},
				},
			},
		})

		if index_start <= i and i <= index_start + 6 then
			entries_container:add(entry_widget)
		end

		if i == index_entry then
			entry_widget.bg = beautiful.accent
			entry_widget.fg = beautiful.bg
		end

		if global_mode == "clients" then
			entry_widget:get_children_by_id("entry_layout")[1]:insert(1, themes_line)
			if filtered[i].max == true then
				themes_line:get_children_by_id("bg")[1]:set_bg(beautiful.green)
			elseif filtered[i].min == true then
				themes_line:get_children_by_id("bg")[1]:set_bg(beautiful.yellow)
			end
		end

		if global_mode == "themes" then
			local color = require("theme.colors." .. entry.name)
			entry_widget.fg = color.fg
			entry_widget:get_children_by_id("stack")[1]:insert(1, entry_image)
			entry_image.image = user.awm_config .. "theme/launcher/" .. entry.name .. ".jpg"
			entry_widget:get_children_by_id("margin")[1].margins = 0
			entry_widget:get_children_by_id("text")[1].halign = "center"
			if i == index_entry then
				entry_widget:get_children_by_id("entry_layout")[1]:insert(1, themes_line)
				entry_widget.bg = beautiful.bg
				entry_widget.fg = color.fg
				themes_line:get_children_by_id("bg")[1]:set_bg(color.fg)
			end
		end
	end

	-- Fix position
	if index_entry > #filtered then
		index_entry, index_start = 1, 1
	elseif index_entry < 1 then
		index_entry = 1
	end

	collectgarbage("collect")
end

function open(mode)
	main:get_children_by_id("image")[1].image =
		gears.surface.load_uncached(user.awm_config .. "theme/launcher/image.jpg")

	local index_modes = {
		["clipboard"] = 2,
		["books"] = 3,
		["themes"] = 4,
		["clients"] = 5,
	}

	if mode ~= nil then
		index_mode = index_modes[mode]
	else
		index_mode = 1
	end

	add_modes()

	global_mode = mode
	-- Reset index and page
	index_start, index_entry = 1, 1

	-- Get entries
	unfiltered = gen(mode)
	filter("")

	-- Prompt
	awful.prompt.run({
		prompt = "Search: ",
		textbox = prompt,
		bg = beautiful.bg,
		fg = beautiful.fg,
		bg_cursor = beautiful.bg_alt,
		done_callback = function()
			launcher.visible = false
		end,
		changed_callback = function(cmd)
			filter(cmd)
		end,
		exe_callback = function()
			if filtered[index_entry] then
				if mode == nil then
					filtered[index_entry].appinfo:launch()
				elseif mode == "clients" then
					awful.client.jumpto(filtered[index_entry].client)
				else
					awful.spawn.with_shell(filtered[index_entry].appinfo)
				end
			end
		end,
		keypressed_callback = function(_, key)
			if key == "Down" then
				next()
			elseif key == "Up" then
				back()
			elseif key == "Tab" then
				index_mode = index_mode + 1
				if index_mode <= 5 then
					mode_change(index_mode)
				else
					mode_change(1)
				end
			end
		end,
	})
end

-- Summon funcs --

function open_launcher(mode)
	if not launcher.visible then
		open(mode)
		launcher.visible = true
	else
		awful.keygrabber.stop()
		launcher.visible = false
	end
end

awesome.connect_signal("open::launcher_books", function()
	open_launcher("books")
end)

awesome.connect_signal("open::launcher_clipboard", function()
	open_launcher("clipboard")
end)

awesome.connect_signal("open::launcher_apps", function()
	open_launcher(nil)
end)

awesome.connect_signal("open::launcher_themes", function()
	open_launcher("themes")
end)

awesome.connect_signal("open::launcher_clients", function()
	open_launcher("clients")
end)
-- hide on click --

client.connect_signal("button::press", function()
	awful.keygrabber.stop()
	launcher.visible = false
end)

awful.mouse.append_global_mousebinding(awful.button({}, 1, function()
	awful.keygrabber.stop()
	launcher.visible = false
end))
