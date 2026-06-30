return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            ruby = { "rubocop" },
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            dockerfile = { "hadolint" },
            sh = { "shellcheck" },
        }

        local grp = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = grp,
            callback = function()
                -- only lint if the linter executable exists (avoids noisy errors)
                local names = lint.linters_by_ft[vim.bo.filetype] or {}
                local runnable = {}
                for _, name in ipairs(names) do
                    local l = lint.linters[name]
                    local cmd = type(l) == "table" and l.cmd or nil
                    if cmd and vim.fn.executable(cmd) == 1 then
                        table.insert(runnable, name)
                    end
                end
                if #runnable > 0 then
                    lint.try_lint(runnable)
                end
            end,
        })
    end,
}
