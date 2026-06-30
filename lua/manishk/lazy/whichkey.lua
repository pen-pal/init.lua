return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup({})
        -- label the <leader> prefix groups so the popup is navigable
        wk.add({
            { "<leader>i", group = "AI (claude / codecompanion)" },
            { "<leader>v", group = "LSP / view / preview" },
            { "<leader>p", group = "find / project / todo" },
            { "<leader>h", group = "git hunks" },
            { "<leader>g", group = "git" },
            { "<leader>d", group = "debug / database-ui" },
            { "<leader>o", group = "org / obsidian / export" },
            { "<leader>q", group = "session" },
            { "<leader>P", group = "pandoc export" },
            { "<leader>R", group = "org-roam" },
            { "<leader>D", group = "database" },
            { "<leader>k", group = "kulala (http)" },
            { "<leader>t", group = "test / trouble / toggles" },
            { "<leader>e", group = "go err snippets" },
            { "<leader>9", group = "99 agent" },
            { "<leader>b", group = "buffer / breakpoint" },
            { "<leader>s", group = "search / spectre" },
            { "<leader>z", group = "zen / lsp restart" },
        })
    end,
}
