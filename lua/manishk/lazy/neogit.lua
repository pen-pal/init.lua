return {
    -- magit equivalent
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (magit)" },
    },
    config = function()
        require("neogit").setup({})
    end,
}
