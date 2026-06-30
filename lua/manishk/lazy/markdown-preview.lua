return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    init = function()
        vim.g.mkdp_auto_close = 0 -- keep preview tab open when switching buffers
    end,
    config = function()
        vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown live preview (browser)" })
    end,
}
