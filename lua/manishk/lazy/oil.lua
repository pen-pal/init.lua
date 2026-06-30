return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = false,
            },
        })
        -- `-` opens the parent dir as an editable buffer (oil convention)
        vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent dir (oil)" })
    end,
}
