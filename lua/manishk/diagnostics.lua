-- Diagnostics appearance + LSP float borders.
vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { prefix = "●", spacing = 2, source = "if_many" },
    float = { border = "rounded", source = true, header = "", prefix = "" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "»",
            [vim.diagnostic.severity.HINT] = "⚑",
        },
    },
})

-- rounded borders on all floats (nvim 0.11+); hover/signature borders are
-- also handled by noice + lsp_signature.
pcall(function() vim.o.winborder = "rounded" end)

-- toggle inline diagnostic virtual text
vim.keymap.set("n", "<leader>vt", function()
    local enabled = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not enabled })
    vim.notify("Diagnostic virtual text " .. (enabled and "off" or "on"))
end, { desc = "Toggle diagnostic virtual text" })
