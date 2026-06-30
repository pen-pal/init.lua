return {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {},
    config = function(_, opts)
        require("kulala").setup(opts)
        vim.keymap.set("n", "<leader>kr", function() require("kulala").run() end, { desc = "Run HTTP request" })
        vim.keymap.set("n", "<leader>kp", function() require("kulala").jump_prev() end, { desc = "Prev request" })
        vim.keymap.set("n", "<leader>kn", function() require("kulala").jump_next() end, { desc = "Next request" })
    end,
}
