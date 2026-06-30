return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local td = require("todo-comments")
        td.setup({})

        -- nav (capital T to avoid clashing with trouble's ]t / [t)
        vim.keymap.set("n", "]T", function() td.jump_next() end, { desc = "Next todo" })
        vim.keymap.set("n", "[T", function() td.jump_prev() end, { desc = "Prev todo" })
        vim.keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Search todos" })
    end,
}
