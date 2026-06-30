return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        -- better text objects: defaults (a=argument, q=quote, b=bracket, …)
        -- plus treesitter class/conditional/loop objects.
        local ai = require("mini.ai")
        ai.setup({
            custom_textobjects = {
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                o = ai.gen_spec.treesitter({
                    a = { "@conditional.outer", "@loop.outer" },
                    i = { "@conditional.inner", "@loop.inner" },
                }),
            },
        })

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

        -- Neovide-like animations. scroll disabled (felt sluggish + fights the
        -- <C-d>zz/<C-u>zz centering remaps); cursor left to smear-cursor.nvim.
        local animate = require("mini.animate")
        animate.setup({
            cursor = { enable = false },
            scroll = { enable = false },
            resize = { enable = true },
            open = { enable = true },
            close = { enable = true },
        })
    end,
}
