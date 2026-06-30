-- Prose/notes + workflow quality-of-life.

-- move by visual line on wrapped text (count-aware: 5j still jumps 5 real lines)
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

local grp = vim.api.nvim_create_augroup("manishk_ux", { clear = true })

-- spell-check + conceal for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    pattern = { "markdown", "org", "text", "gitcommit", "tex" },
    callback = function()
        vim.opt_local.spell = true
        local ft = vim.bo.filetype
        if ft == "markdown" or ft == "org" then
            vim.opt_local.conceallevel = 2
        end
    end,
})

-- restore cursor to last edit position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    group = grp,
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- auto-create missing parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = grp,
    callback = function(args)
        if args.match:match("^%w+://") then return end -- skip remote/url buffers
        local dir = vim.fn.fnamemodify(args.file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- toggle format-on-save (conform reads vim.g.disable_autoformat)
vim.g.disable_autoformat = false
vim.api.nvim_create_user_command("FormatToggle", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end, { desc = "Toggle format-on-save" })
