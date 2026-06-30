return {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
        hint_enable = false,
        floating_window = true,
        toggle_key = "<C-k>",
    },
    config = function(_, opts)
        require("lsp_signature").setup(opts)
    end,
}
