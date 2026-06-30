return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gs = require("gitsigns")
        gs.setup({
            on_attach = function(bufnr)
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- navigate hunks
                map("n", "]c", function() gs.nav_hunk("next") end, "Next git hunk")
                map("n", "[c", function() gs.nav_hunk("prev") end, "Prev git hunk")

                -- actions
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                map("n", "<leader>hd", gs.diffthis, "Diff this")
                map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
            end,
        })
    end,
}
