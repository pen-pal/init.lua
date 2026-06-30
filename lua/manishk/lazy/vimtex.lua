return {
    "lervag/vimtex",
    ft = { "tex", "latex", "bib" },
    init = function()
        -- compile with latexmk (MacTeX provides it)
        vim.g.vimtex_compiler_method = "latexmk"
        -- PDF viewer with SyncTeX (forward/inverse search). Needs Skim.app.
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
        vim.g.vimtex_quickfix_mode = 0
        vim.g.vimtex_mappings_enabled = 1
        -- default maps use <localleader>: \ll compile, \lv view, \lc clean
    end,
}
