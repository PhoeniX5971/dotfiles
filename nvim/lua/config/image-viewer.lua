require("image").setup({
    backend = "kitty", -- use kitty backend
    kitty_method = "icat", -- use sixel method for kitty
    max_width = 100,
    max_height = 20,
    max_width_window_percentage = math.huge,
    max_height_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
})

local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local Path = require("plenary.path")
local image = require("image") -- your image.nvim module

local image_previewer = previewers.new_buffer_previewer({
    define_preview = function(self, entry, status)
        local filepath = entry.path or entry.value
        if not Path:new(filepath):exists() then
            return
        end

        -- Clear existing images in the preview window
        vim.api.nvim_buf_clear_namespace(self.state.bufnr, -1, 0, -1)

        -- Render image using image.nvim
        image.display(filepath, { win = vim.api.nvim_get_current_win() })
    end,
})

require("telescope").setup({
    defaults = {
        layout_config = {
            preview_cutoff = 1,
            width = 0.8,
            height = 0.8,
        },
    },
    extensions = {
        media_files = {
            filetypes = { "png", "jpg", "jpeg", "gif", "bmp", "webp" },
            find_cmd = "rg",
            previewer = image_previewer, -- use the kitty previewer
        },
    },
})

require("telescope").load_extension("media_files")
