require("telescope").setup({
    defaults = {
        layout_config = {
            preview_cutoff = 1, -- Always show preview
            width = 0.8,
        },
        sorting_strategy = "ascending",
    },
    extensions = {
        media_files = {
            filetypes = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "svg", "pdf" },
            find_cmd = "rg", -- Use fd to find files
            -- Optionally set 'chafa' as the preview command
            previewers = {
                chafa = { use = true },
            },
        },
    },
})

require("telescope").load_extension("media_files")
