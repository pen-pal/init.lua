return {
    -- Multi-provider AI chat + inline edits. Default adapter = anthropic,
    -- which needs ANTHROPIC_API_KEY in the environment (separate from the
    -- Claude Code subscription). Swap the adapter for openai/copilot/ollama
    -- if you prefer.
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = { adapter = "anthropic" },
                inline = { adapter = "anthropic" },
            },
        })
    end,
    keys = {
        { "<leader>io", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion: chat" },
        { "<leader>ip", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: actions" },
        { "<leader>ii", ":CodeCompanion<cr>", mode = "v", desc = "CodeCompanion: inline edit" },
    },
}
