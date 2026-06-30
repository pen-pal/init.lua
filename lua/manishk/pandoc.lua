-- pandoc export helpers: convert the current buffer (markdown, rst, org, docx,
-- epub, …) to PDF/HTML/docx and open the result. Requires `pandoc` (and a LaTeX
-- engine for PDF — MacTeX's pdflatex).
local function export(ext, open)
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to export", vim.log.levels.WARN)
        return
    end
    if vim.fn.executable("pandoc") ~= 1 then
        vim.notify("pandoc not installed", vim.log.levels.ERROR)
        return
    end
    vim.cmd("silent write")
    local out = vim.fn.expand("%:p:r") .. "." .. ext
    vim.notify("pandoc → " .. ext .. " …", vim.log.levels.INFO)
    local cmd = { "pandoc", file, "-o", out }
    if ext == "pdf" then
        -- xelatex handles unicode (emoji, ⌥, box-drawing) that pdflatex rejects
        table.insert(cmd, "--pdf-engine=xelatex")
    end
    vim.system(cmd, { text = true }, function(res)
        vim.schedule(function()
            if res.code == 0 then
                vim.notify("pandoc: " .. out, vim.log.levels.INFO)
                if open then vim.system({ "open", out }) end
            else
                vim.notify("pandoc failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
            end
        end)
    end)
end

vim.keymap.set("n", "<leader>Pp", function() export("pdf", true) end, { desc = "Pandoc export PDF" })
vim.keymap.set("n", "<leader>Ph", function() export("html", true) end, { desc = "Pandoc export HTML" })
vim.keymap.set("n", "<leader>Pd", function() export("docx", true) end, { desc = "Pandoc export docx" })

return {}
