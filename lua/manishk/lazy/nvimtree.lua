return {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    config = function()
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
                icons = {
                    glyphs = {
                        -- NOTE: `default`/`symlink` and two git icons are nerd-font characters.
                        -- If they look empty, paste yours back from your old file.
                        default = "",
                        symlink = "",
                        git = {
                            unstaged  = "✗",
                            staged    = "✓",
                            untracked = "★",
                            renamed   = "➜",
                            unmerged  = "",
                            deleted   = "",
                            ignored   = "◌",
                        },
                    },
                },
            },
            filters = {
                dotfiles = true,
            },
        })

	    -- nvim-tree.lua
	    vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>")
    end
}
