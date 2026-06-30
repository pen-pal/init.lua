return {
    -- inline images/PDF/math — works in Ghostty/Kitty/WezTerm (NOT Alacritty).
    -- needs imagemagick (`magick`) + ghostscript (`gs`), both installed.
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki", "org", "tex", "typst" },
    opts = {
        backend = "kitty",
        processor = "magick_cli", -- uses imagemagick CLI; no luarocks needed
        integrations = {
            markdown = {
                enabled = true,
                only_render_image_at_cursor = false,
                filetypes = { "markdown", "vimwiki" },
            },
            neorg = { enabled = false },
            typst = { enabled = true },
            html = { enabled = false },
            css = { enabled = false },
        },
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = nil,
        max_height_window_percentage = 30,
        window_overlap_clear_enabled = true,
        editor_only_render_when_focused = true,
        tmux_show_only_in_active_window = true,
    },
}
