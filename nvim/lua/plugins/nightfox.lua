-- return {
--   { "EdenEast/nightfox.nvim", priority = 1000 },
-- }

return {
  {
    "EdenEast/nightfox.nvim", -- Example for Nightfox
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true, -- Enable transparency
          styles = {
            comments = "italic", -- Optional: Customize text styles
          },
        },
      })
    end,
  },
}
