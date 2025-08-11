-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- require("nightfox").setup({
--     options = {
--         transparent = true, -- Ensure transparency is off
--     },
--     palettes = {
--         carbonfox = {
--             bg0 = "#040619", -- Background
--             fg1 = "#e0cef3", -- Foreground
--             blue = "#355BBF",
--             cyan = "#2398E3",
--             purple = "#9974E8",
--             light_blue = "#698CEC",
--         },
--     },
--     groups = {
--         carbonfox = {
--             Normal = { fg = "#e0cef3", bg = "#040619" },
--             Comment = { fg = "#9c90aa" },
--             Keyword = { fg = "#9974E8" },
--             Identifier = { fg = "#5B6BDB" },
--             Function = { fg = "#698CEC" },
--             String = { fg = "#2398E3" },
--             Type = { fg = "#9D99F2" },
--         },
--     },
-- })
--
vim.cmd.colorscheme("carbonfox") -- Apply the theme

-- Make background transparent {
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" }) -- For inactive windows
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" }) -- Empty line markers
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" }) -- Gutter (line numbers)
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" }) -- Transparency for Telescope
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE" }) -- Transparent border

vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" }) -- Line numbers
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" }) -- Current line number

vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" }) -- Split borders
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" }) -- Status line
vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" }) -- Current line
vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" }) -- Vertical splits
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" }) -- Popup menu (autocomplete)
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" }) -- Floating window borders

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" }) -- Floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" }) -- Borders of floating windows
-- }

-- Set background to solid color
-- vim.cmd([[colorscheme carbonfox]])

-- -- Code to use terminal colors
-- vim.opt.termguicolors = false
vim.opt.background = "dark"
-- vim.cmd("colorscheme default")

-- Set Indentation
vim.opt.tabstop = 4 -- Sets the number of spaces that a <Tab> in the file will represent
vim.opt.softtabstop = 4 -- Sets the number of spaces that a <Tab> character will represent when editing
vim.opt.shiftwidth = 4 -- Sets the number of spaces to use for each step of (auto)indent
vim.opt.expandtab = false -- Prevents tabs from being expanded to spaces

-- In your LazyVim config or init.vim file, add this to set clangd-specific settings
vim.g.clangd_formatting_enabled = true
vim.g.clangd_flags = { "--clang-tidy", "--style=google", "--tab-width=4", "--use-tab" }

-- Ensure Clangd uses these settings
-- vim.cmd([[
--   augroup ClangdFormatting
--     autocmd!
--     autocmd FileType c,cpp lua vim.lsp.buf.formatting_sync(nil, 1000)
--   augroup END
-- ]])
