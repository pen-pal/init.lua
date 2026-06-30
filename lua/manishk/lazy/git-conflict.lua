return {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        -- default mappings (in conflict buffers): co ours, ct theirs, cb both,
        -- c0 none, ]x / [x next/prev conflict
        require("git-conflict").setup({
            default_mappings = true,
        })
    end,
}
