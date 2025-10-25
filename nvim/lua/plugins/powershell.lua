local mason_path = vim.fn.expand("~") .. "/.local/share/nvim/mason/packages/powershell-editor-services"

return {
    "TheLeoP/powershell.nvim",

    opts = {
        bundle_path = mason_path,
    },
}
