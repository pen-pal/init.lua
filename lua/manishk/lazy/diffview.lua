return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    config = function()
        require("diffview").setup({})
        vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
        vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (this file)" })
        vim.keymap.set("n", "<leader>gQ", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
    end,
}
