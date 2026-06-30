return {
    -- Neovide-style animated smear/trail cursor, in the terminal.
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        smear_insert_mode = true,
    },
}
