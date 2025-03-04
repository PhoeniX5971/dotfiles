-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set background to solid color
vim.cmd([[colorscheme carbonfox]])

-- -- Code to use terminal colors
-- vim.opt.termguicolors = false
-- vim.opt.background = "dark"
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
vim.cmd([[
  augroup ClangdFormatting
    autocmd!
    autocmd FileType c,cpp lua vim.lsp.buf.formatting_sync(nil, 1000)
  augroup END
]])
