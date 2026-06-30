return {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
        "nvim-orgmode/org-bullets.nvim",
    },
    config = function()
        require("orgmode").setup({
            org_agenda_files = "~/org/**/*",
            org_default_notes_file = "~/org/refile.org",
            org_todo_keywords = { "TODO", "NEXT", "WAITING", "|", "DONE", "CANCELLED" },
            org_capture_templates = {
                t = {
                    description = "Task",
                    template = "* TODO %?\n  %u",
                    target = "~/org/todo.org",
                },
                n = {
                    description = "Note",
                    template = "* %?\n  %u",
                    target = "~/org/notes.org",
                },
                j = {
                    description = "Journal",
                    template = "* %<%H:%M> %?",
                    target = "~/org/dailies/%<%Y-%m-%d>.org",
                },
            },
        })

        require("org-bullets").setup()

        -- ── invisible emacs backend (headless --batch) for babel + export ──
        -- emacs is never opened; nvim shells out, emacs does the work and exits.
        local function emacs_batch(extra, label, reload)
            if vim.bo.filetype ~= "org" then
                vim.notify("Not an .org buffer", vim.log.levels.WARN)
                return
            end
            if vim.fn.executable("emacs") ~= 1 then
                vim.notify("emacs not installed/working — backend unavailable", vim.log.levels.ERROR)
                return
            end
            local file = vim.fn.expand("%:p")
            vim.cmd("silent write")
            vim.notify("emacs: " .. label .. " …", vim.log.levels.INFO)

            local cmd = { "emacs", "--batch", file }
            vim.list_extend(cmd, extra)
            vim.system(cmd, { text = true }, function(res)
                vim.schedule(function()
                    if res.code == 0 then
                        vim.notify("emacs: " .. label .. " ✓", vim.log.levels.INFO)
                        if reload then vim.cmd("checktime") end
                    else
                        vim.notify("emacs " .. label .. " failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
                    end
                end)
            end)
        end

        local babel_eval = table.concat({
            "(progn",
            "  (require 'org)",
            "  (setq org-confirm-babel-evaluate nil)",
            "  (org-babel-do-load-languages 'org-babel-load-languages",
            "    '((emacs-lisp . t) (shell . t) (python . t) (C . t) (sql . t) (js . t) (awk . t)))",
            "  (org-babel-execute-buffer)",
            "  (save-buffer))",
        }, " ")

        vim.keymap.set("n", "<leader>oeh", function() emacs_batch({ "-f", "org-html-export-to-html" }, "export HTML") end, { desc = "Org export HTML (emacs)" })
        vim.keymap.set("n", "<leader>oep", function() emacs_batch({ "-f", "org-latex-export-to-pdf" }, "export PDF") end, { desc = "Org export PDF (emacs)" })
        vim.keymap.set("n", "<leader>oex", function() emacs_batch({ "--eval", babel_eval }, "babel execute", true) end, { desc = "Org babel execute buffer (emacs)" })
    end,
}
