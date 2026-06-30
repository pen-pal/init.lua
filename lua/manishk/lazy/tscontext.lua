return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("treesitter-context").setup({
            max_lines = 3,
            multiline_threshold = 1,
        })
        vim.keymap.set("n", "[x", function()
            require("treesitter-context").go_to_context()
        end, { silent = true, desc = "Jump to context" })
    end,
}
