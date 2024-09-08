local gears = require("gears")
local awful = require("awful")

function reload_nvim(entry)
	awful.spawn.easy_async_with_shell("ls -1 /run/user/1000/ | grep nvim ", function(stdout)
		for line in stdout:gmatch("[^\n]+") do
			awful.spawn([[
				nvim --server /run/user/1000/]] ..line.. [[ --remote-send '<C-\><C-N>:colorscheme ]] ..entry.. [[<CR>'
			]])
		end
	end)
end
