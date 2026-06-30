return {
    "stevearc/aerial.nvim",
    keys = { "<leader>cs" },
    cmd = { "AerialToggle", "AerialOpen" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("aerial").setup({
            backends = { "treesitter", "lsp", "markdown" },
        })
        vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle!<cr>", { desc = "Symbol outline" })
    end,
}
