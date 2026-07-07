return {
    -- inline images/PDF/math — works in Ghostty/Kitty/WezTerm (NOT Alacritty).
    -- needs imagemagick (`magick`) + ghostscript (`gs`), both installed.
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki", "org", "tex", "typst" },
    opts = {
        backend = "kitty",
        processor = "magick_cli", -- uses imagemagick CLI; no luarocks needed
        integrations = {
            -- markdown/org inline images now handled by snacks.image (doc);
            -- image.nvim kept only as the library behind :PreviewImage.
            markdown = {
                enabled = false,
            },
            neorg = { enabled = false },
            typst = { enabled = true },
            html = { enabled = false },
            css = { enabled = false },
        },
        -- no tiny caps: let the preview pane fill its split (was max_height=12
        -- rows + 30% which shrank everything to a thumbnail). Width-capped to
        -- the window; height free so tall pages render and scroll.
        max_width_window_percentage = 100,
        max_height_window_percentage = nil,
        window_overlap_clear_enabled = true,
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = true,
    },
}
