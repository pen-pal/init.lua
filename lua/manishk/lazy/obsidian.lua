return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("obsidian").setup({
            legacy_commands = false,
            workspaces = {
                { name = "notes", path = "~/notes" },
            },
            daily_notes = {
                folder = "dailies",
            },
            -- disable concealing UI so plain markdown stays readable
            ui = { enable = false },
        })
        vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New note" })
        vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
        vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick switch note" })
        vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
        vim.keymap.set("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Daily note" })
    end,
}
