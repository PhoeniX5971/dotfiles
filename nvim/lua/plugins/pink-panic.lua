-- return {
--     {
--         "https://github.com/Scysta/pink-panic.nvim", -- Example for Nightfox
--         config = function()
--             require("material").setup({
--                 options = {
--                     transparent = true, -- Enable transparency
--                     styles = {
--                         comments = "italic", -- Optional: Customize text styles
--                     },
--                 },
--             })
--         end,
--     },
-- }
return {
    "rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
    { "Scysta/pink-panic.nvim", name = "pink-panic", priority = 1000 },
}
