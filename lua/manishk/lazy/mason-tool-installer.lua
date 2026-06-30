return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- formatters (conform)
                "stylua",
                "prettier",
                "clang-format",
                -- linters (nvim-lint)
                "eslint_d",
                "shellcheck",
                "hadolint",
            },
            run_on_start = true,
        })
    end,
}
