-- Universal in-editor preview (emacs-style): render images / pdf / markdown /
-- html / latex / docx into an image and show it in a side split.
--
-- Pipeline: images shown directly; everything else is rendered to PDF
-- (pandoc or latexmk), the PDF pages are rasterized with ghostscript and
-- stitched into one tall PNG (imagemagick), then displayed via image.nvim.
--
-- Requires a graphics terminal (Ghostty/Kitty/WezTerm) + image.nvim, plus
-- gs, magick, pandoc, latexmk (all installed). Static snapshot — re-run to
-- refresh.
local M = {}

local IMG_EXT = { png = true, jpg = true, jpeg = true, gif = true, webp = true, bmp = true, svg = true, avif = true }
-- document-style formats → pandoc → PDF. (html is handled by a real browser
-- instead, since pandoc can't run JS / load CSS / Tailwind.)
local PANDOC_EXT = { md = true, markdown = true, rst = true, org = true, docx = true, epub = true }

-- find a Chromium-based browser for rendering real web pages (CSS/JS/Tailwind)
local function find_browser()
    local candidates = {
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        "/Applications/Chromium.app/Contents/MacOS/Chromium",
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
        "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
        "/Applications/Arc.app/Contents/MacOS/Arc",
    }
    for _, b in ipairs(candidates) do
        if vim.fn.executable(b) == 1 then return b end
    end
    return nil
end

local function tmpfile(ext)
    return vim.fn.tempname() .. "." .. ext
end

-- rasterize a PDF into one tall PNG (all pages appended), call cb(png|nil, err)
local function pdf_to_png(pdf, cb)
    local prefix = vim.fn.tempname()
    vim.system({
        "gs", "-dBATCH", "-dNOPAUSE", "-dQUIET", "-sDEVICE=png16m", "-r150",
        "-sOutputFile=" .. prefix .. "-%03d.png", pdf,
    }, {}, function(r)
        vim.schedule(function()
            if r.code ~= 0 then return cb(nil, r.stderr) end
            local pages = vim.fn.glob(prefix .. "-*.png", false, true)
            table.sort(pages)
            if #pages == 0 then return cb(nil, "ghostscript produced no pages") end
            if #pages == 1 then return cb(pages[1]) end
            local png = tmpfile("png")
            local cmd = { "magick" }
            for _, p in ipairs(pages) do cmd[#cmd + 1] = p end
            cmd[#cmd + 1] = "-append"
            cmd[#cmd + 1] = png
            vim.system(cmd, {}, function(r2)
                vim.schedule(function()
                    cb(r2.code == 0 and png or nil, r2.stderr)
                end)
            end)
        end)
    end)
end

-- render the current file to a PNG, call cb(png|nil, err)
local function render_to_png(file, ext, cb)
    if ext == "html" or ext == "htm" then
        -- render real web pages with a headless browser (runs JS, loads CSS/CDN)
        local browser = find_browser()
        if not browser then
            return cb(nil, "no Chromium-based browser found to render HTML")
        end
        local png = tmpfile("png")
        vim.system({
            browser, "--headless=new", "--disable-gpu", "--hide-scrollbars",
            "--virtual-time-budget=3000", -- let JS/CDN (Tailwind, fonts) finish
            "--screenshot=" .. png, "--window-size=1440,2400",
            "file://" .. file,
        }, {}, function(r)
            vim.schedule(function()
                -- chrome may exit non-zero on macOS despite success; check file
                if vim.fn.filereadable(png) == 1 then cb(png) else cb(nil, r.stderr) end
            end)
        end)
    elseif ext == "pdf" then
        pdf_to_png(file, cb)
    elseif ext == "tex" or ext == "latex" then
        local outdir = vim.fn.fnamemodify(file, ":h")
        vim.system({
            "latexmk", "-pdf", "-interaction=nonstopmode", "-halt-on-error",
            "-outdir=" .. outdir, file,
        }, {}, function(r)
            vim.schedule(function()
                local pdf = vim.fn.fnamemodify(file, ":r") .. ".pdf"
                if vim.fn.filereadable(pdf) == 1 then
                    pdf_to_png(pdf, cb)
                else
                    cb(nil, r.stderr)
                end
            end)
        end)
    elseif PANDOC_EXT[ext] then
        local pdf = tmpfile("pdf")
        -- xelatex handles unicode (emoji, ⌥, box-drawing) that pdflatex rejects
        vim.system({ "pandoc", file, "--pdf-engine=xelatex", "-o", pdf }, {}, function(r)
            vim.schedule(function()
                if r.code == 0 then pdf_to_png(pdf, cb) else cb(nil, r.stderr) end
            end)
        end)
    else
        cb(nil, "unsupported file type: ." .. ext)
    end
end

local state = { win = nil, buf = nil, img = nil }

local function display(png)
    local ok, image = pcall(require, "image")
    if not ok then
        vim.notify("image.nvim not available", vim.log.levels.ERROR)
        return
    end

    -- clear previous render
    if state.img then pcall(function() state.img:clear() end) end

    -- reuse the preview window/buffer if still open, else make a new vsplit
    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
        vim.cmd("botright vsplit")
        state.win = vim.api.nvim_get_current_win()
        state.buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(state.win, state.buf)
        vim.bo[state.buf].filetype = "preview"
        vim.bo[state.buf].buftype = "nofile"
        vim.wo[state.win].number = false
        vim.wo[state.win].relativenumber = false
        vim.wo[state.win].cursorline = false
        vim.cmd("wincmd p")
    end
    -- give the buffer rows so the image has vertical room to scroll into
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, vim.fn["repeat"]({ "" }, 400))

    state.img = image.from_file(png, {
        window = state.win,
        buffer = state.buf,
        with_virtual_padding = true,
        x = 0,
        y = 0,
        width = vim.api.nvim_win_get_width(state.win),
    })
    state.img:render()
end

function M.preview()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    if vim.bo.modified then vim.cmd("silent write") end
    local ext = vim.fn.expand("%:e"):lower()

    if IMG_EXT[ext] then
        display(file)
        return
    end
    vim.notify("Rendering preview…", vim.log.levels.INFO)
    render_to_png(file, ext, function(png, err)
        if png then
            display(png)
        else
            vim.notify("Preview failed:\n" .. (err or "unknown"), vim.log.levels.ERROR)
        end
    end)
end

function M.close()
    if state.img then pcall(function() state.img:clear() end) end
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end
    state = { win = nil, buf = nil, img = nil }
end

vim.api.nvim_create_user_command("Preview", M.preview, {})
vim.api.nvim_create_user_command("PreviewClose", M.close, {})
vim.keymap.set("n", "<leader>vp", M.preview, { desc = "Preview file in split (image/pdf/md/html/tex)" })
vim.keymap.set("n", "<leader>vP", M.close, { desc = "Close preview split" })

return M
