return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",
    cmd = "Telescope",
    keys = { "<leader>pf", "<C-p>", "<leader>pws", "<leader>pWs", "<leader>ps", "<leader>vh", "<leader>pM" },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-media-files.nvim",
    },

    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {},
                media_files = {
                    filetypes = { "png", "webp", "jpg", "jpeg", "gif", "pdf", "svg", "mp4", "webm", "mov", "mkv" },
                    find_cmd = "rg",
                },
            },
        })
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'media_files')

        local preview_utils = require("telescope.previewers.utils")
        preview_utils.ts_highlighter = function(bufnr, ft)
            if not ft or ft == "" then
                return false
            end
            local lang = vim.treesitter.language.get_lang(ft) or ft
            if not lang or lang == "" then
                return false
            end

            return pcall(vim.treesitter.start, bufnr, lang)
        end

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>pM', '<cmd>Telescope media_files<cr>', { desc = "Media files (telescope, blocky preview)" })
    end
}

