return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { [[<c-\>]] },
    cmd = { "ToggleTerm", "TermExec" },
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = { border = "curved" },
        })
    end,
}
