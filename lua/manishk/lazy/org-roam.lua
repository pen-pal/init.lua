return {
    "chipsenkbeil/org-roam.nvim",
    ft = "org",
    dependencies = { "nvim-orgmode/orgmode" },
    config = function()
        require("org-roam").setup({
            directory = "~/org/roam",
            -- prefix moved off <leader>nr so it doesn't delay <leader>n (nvim-tree)
            bindings = {
                prefix = "<leader>R",
            },
        })
    end,
}
