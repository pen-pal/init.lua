return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        -- better text objects (around/inside): aiwf, brackets, quotes, etc.
        require("mini.ai").setup({})

        -- move lines/selections with <M-j>/<M-k> (horizontal disabled to avoid
        -- clashing with <M-h> tmux-sessionizer binding)
        require("mini.move").setup({
            mappings = {
                down = "<M-j>",
                up = "<M-k>",
                line_down = "<M-j>",
                line_up = "<M-k>",
                left = "",
                right = "",
                line_left = "",
                line_right = "",
            },
        })

        -- delete buffer without closing the window/split
        require("mini.bufremove").setup({})
        vim.keymap.set("n", "<leader>bd", function()
            require("mini.bufremove").delete(0, false)
        end, { desc = "Delete buffer" })
    end,
}
