return {
    -- Claude Code inside Neovim — reuses your existing `claude` CLI + login
    -- (no API key). Send selections, add buffers, apply diffs in-editor.
    "coder/claudecode.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("claudecode").setup({
            terminal = {
                provider = "native",
                split_side = "right",
                split_width_percentage = 0.35,
            },
        })
    end,
    keys = {
        { "<leader>ic", "<cmd>ClaudeCode<cr>", desc = "Claude Code: toggle" },
        { "<leader>if", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code: focus" },
        { "<leader>ir", "<cmd>ClaudeCode --resume<cr>", desc = "Claude Code: resume" },
        { "<leader>iC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude Code: continue" },
        { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude Code: add current buffer" },
        { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Code: send selection" },
        { "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Code: accept diff" },
        { "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude Code: deny diff" },
    },
}
