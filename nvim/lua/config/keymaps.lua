-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>ip", function()
  require("telescope").extensions.media_files.media_files({ cwd = vim.fn.expand("%:p:h") })
end, { noremap = true, silent = true, desc = "Preview Images in Current Directory" })
