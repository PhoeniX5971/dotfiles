local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Prettier with custom arguments
        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--tab-width", "4", "--use-tabs" }, -- Set tab width to 8 and use tabs
        }),
    },
})
