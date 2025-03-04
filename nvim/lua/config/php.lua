return {
        { "stevearc/conform.nvim", optional = true, opts = { formatters_by_ft = { php = { "php_cs_fixer" } } } },
        {
                "nvim-treesitter",
                opts = function(_, opts)
                        opts.ensure_installed = { "php" }
                end,
        },
        {
                "neovim/nvim-lspconfig",
                opts = {
                        servers = {
                                phpactor = { enabled = true },
                                intelephense = { enabled = true },
                        },
                },
        },
}
