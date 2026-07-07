return {
    -- Only the `image` module: crisp in-editor rendering of images AND pdfs
    -- (emacs DocView-style — open the file, see the document). Needs a
    -- graphics terminal (Ghostty/kitty) + tmux allow-passthrough; in
    -- Alacritty it just doesn't hijack, text view stays.
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        image = {
            enabled = true,
            doc = {
                enabled = true,     -- render images in markdown/org inline
                inline = true,
                float = true,
            },
        },
        -- everything else off — image module only
        bigfile = { enabled = false },
        dashboard = { enabled = false },
        indent = { enabled = false },
        input = { enabled = false },
        notifier = { enabled = false },
        -- picker: used for media browsing — its preview pane renders images
        -- CRISP via snacks.image (telescope's previewer is text-only, can't).
        picker = { enabled = true },
        quickfile = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
    },
    keys = {
        {
            "<leader>pm",
            function()
                Snacks.picker.files({
                    ft = { "png", "jpg", "jpeg", "gif", "webp", "bmp", "svg", "pdf" },
                })
            end,
            desc = "Media files (crisp preview — snacks)",
        },
    },
}
