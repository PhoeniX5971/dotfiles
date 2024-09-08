-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- setup must be called before loading the colorscheme
-- Default options:
require("oneDarkPro").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme oneDarkPro")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme oneDarkPro]])
