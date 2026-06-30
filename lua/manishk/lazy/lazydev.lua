return {
    -- Lua LSP completion/types for the Neovim API and your plugins while
    -- editing this config. Successor to the (archived) neodev.nvim.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- luvit / vim.uv types, loaded when `vim.uv` is referenced
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
