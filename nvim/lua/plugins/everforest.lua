return {
        {
                "marko-cerovac/material.nvim", -- Example for Nightfox
                config = function()
                        require("material").setup({
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
