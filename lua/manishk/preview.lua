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
        "gs", "-dBATCH", "-dNOPAUSE", "-dQUIET", "-sDEVICE=png16m", "-r200",
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
            "--virtual-time-budget=3500",      -- let JS/CDN (Tailwind, fonts) finish
            "--force-device-scale-factor=2",   -- 2x DPI → crisp, readable text
            "--screenshot=" .. png, "--window-size=1500,3200",
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

local function close_preview()
    if state.img then pcall(function() state.img:clear() end) end
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        pcall(vim.api.nvim_win_close, state.win, true)
    end
    state = { win = nil, buf = nil, img = nil }
end

local function display(png)
    local ok, image = pcall(require, "image")
    if not ok then
        vim.notify("image.nvim not available", vim.log.levels.ERROR)
        return
    end

    -- pixel dimensions of the rendered image
    local dim = vim.fn.system({ "magick", "identify", "-format", "%w %h", png })
    local iw, ih = dim:match("(%d+)%s+(%d+)")
    iw, ih = tonumber(iw) or 1440, tonumber(ih) or 2400

    -- solid opaque background for the preview window so the desktop/other
    -- windows don't bleed through (the global Normal is bg=none/transparent).
    vim.api.nvim_set_hl(0, "PreviewNormal", { bg = "#0b0e14", fg = "#c0caf5" })

    -- one clean preview window (close any previous, open a fresh vsplit ~55%)
    close_preview()
    local src_win = vim.api.nvim_get_current_win()
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.55))
    state.win = vim.api.nvim_get_current_win()
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].filetype = "preview"
    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false
    vim.wo[state.win].cursorline = false
    vim.wo[state.win].list = false
    vim.wo[state.win].winhighlight = "Normal:PreviewNormal,NormalNC:PreviewNormal,EndOfBuffer:PreviewNormal"

    -- keep focus on the source file immediately
    if vim.api.nvim_win_is_valid(src_win) then
        vim.api.nvim_set_current_win(src_win)
    end

    -- defer sizing+render until the split has actually been laid out, else
    -- nvim_win_get_width returns a stale (pre-layout) value → wrong size.
    vim.schedule(function()
        if not (state.win and vim.api.nvim_win_is_valid(state.win)) then return end
        -- fill the split width; derive height from aspect (cells are ~2x
        -- taller than wide, hence the /2) so it isn't a narrow strip.
        local cols = vim.api.nvim_win_get_width(state.win)
        local rows = math.max(1, math.floor(cols * ih / (iw * 2)))
        vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, vim.fn["repeat"]({ "" }, rows + 2))

        local ok_img, img = pcall(image.from_file, png, {
            window = state.win,
            buffer = state.buf,
            with_virtual_padding = true,
            x = 0,
            y = 0,
            width = cols,
        })
        state.img = ok_img and img or nil
        if not state.img then
            vim.notify(
                "image.nvim couldn't render. Need a graphics terminal (Ghostty/kitty) + tmux allow-passthrough. In Alacritty use <leader>vp (chafa).",
                vim.log.levels.WARN
            )
            close_preview()
            return
        end
        local render_ok = pcall(function() state.img:render() end)
        if not render_ok then
            vim.notify("image.nvim render failed", vim.log.levels.WARN)
            close_preview()
            return
        end
        -- flush any stray graphics/cursor escapes left on screen
        vim.schedule(function() vim.cmd("redraw!") end)
    end)
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
    close_preview()
end

-- Open the file's rendered form in the proper native app (browser / Preview /
-- Skim). Reliable + crisp + scrollable — the recommended preview. Images, pdf
-- and html open directly; md/rst/org/docx are converted to html first; tex is
-- compiled to pdf first.
local function sys_open(path)
    if vim.ui and vim.ui.open then
        vim.ui.open(path)
    else
        vim.system({ "open", path })
    end
end

function M.open_external()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    if vim.bo.modified then vim.cmd("silent write") end
    local ext = vim.fn.expand("%:e"):lower()

    if IMG_EXT[ext] or ext == "pdf" or ext == "html" or ext == "htm" then
        sys_open(file)
    elseif ext == "md" or ext == "markdown" then
        -- live browser preview if available, else pandoc -> html
        if vim.fn.exists(":MarkdownPreview") ~= 0 then
            vim.cmd("MarkdownPreview")
        else
            local out = tmpfile("html")
            vim.system({ "pandoc", file, "-o", out }, {}, function(r)
                vim.schedule(function()
                    if r.code == 0 then sys_open(out) else vim.notify(r.stderr or "pandoc failed", vim.log.levels.ERROR) end
                end)
            end)
        end
    elseif PANDOC_EXT[ext] then
        local out = tmpfile("html")
        vim.notify("pandoc → html …", vim.log.levels.INFO)
        vim.system({ "pandoc", file, "-o", out }, {}, function(r)
            vim.schedule(function()
                if r.code == 0 then sys_open(out) else vim.notify(r.stderr or "pandoc failed", vim.log.levels.ERROR) end
            end)
        end)
    elseif ext == "tex" or ext == "latex" then
        local outdir = vim.fn.fnamemodify(file, ":h")
        vim.notify("latexmk → pdf …", vim.log.levels.INFO)
        vim.system({ "latexmk", "-pdf", "-interaction=nonstopmode", "-outdir=" .. outdir, file }, {}, function(r)
            vim.schedule(function()
                local pdf = vim.fn.fnamemodify(file, ":r") .. ".pdf"
                if vim.fn.filereadable(pdf) == 1 then sys_open(pdf) else vim.notify(r.stderr or "latexmk failed", vim.log.levels.ERROR) end
            end)
        end)
    else
        sys_open(file)
    end
end

-- Render an image path in a terminal split via chafa. chafa auto-detects the
-- terminal: crisp kitty/sixel graphics in Ghostty/kitty, unicode blocks in
-- Alacritty (lower-res but works with NO graphics protocol).
local function chafa_in_split(img)
    if vim.fn.executable("chafa") ~= 1 then
        vim.notify("chafa not installed (brew install chafa)", vim.log.levels.ERROR)
        return
    end
    close_preview()
    local src = vim.api.nvim_get_current_win()
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.5))
    state.win = vim.api.nvim_get_current_win()
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    local w = vim.api.nvim_win_get_width(state.win)
    local h = vim.api.nvim_win_get_height(state.win)
    local cmd = string.format("chafa --animate off --size=%dx%d %s", w, math.max(1, h - 1), vim.fn.shellescape(img))
    vim.api.nvim_set_current_win(state.win)
    vim.fn.jobstart({ "sh", "-c", cmd }, { term = true })
    vim.bo[state.buf].filetype = "preview"
    if vim.api.nvim_win_is_valid(src) then vim.api.nvim_set_current_win(src) end
end

-- Universal in-editor preview via chafa (works in Alacritty AND Ghostty).
function M.preview_chafa()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    local ext = vim.fn.expand("%:e"):lower()
    if IMG_EXT[ext] then
        chafa_in_split(file)
    elseif ext == "pdf" then
        local png = tmpfile("png")
        vim.notify("rendering pdf…", vim.log.levels.INFO)
        vim.system({
            "gs", "-dBATCH", "-dNOPAUSE", "-dQUIET", "-dFirstPage=1", "-dLastPage=1",
            "-sDEVICE=png16m", "-r150", "-sOutputFile=" .. png, file,
        }, {}, function(r)
            vim.schedule(function()
                if vim.fn.filereadable(png) == 1 then chafa_in_split(png)
                else vim.notify(r.stderr or "gs failed", vim.log.levels.ERROR) end
            end)
        end)
    else
        vim.notify("chafa preview = images/pdf. Use <leader>vo (native app) for docs.", vim.log.levels.WARN)
    end
end

-- Open current file in the Emacs GUI (crisp): DocView renders PDFs (via gs),
-- native image display, eww for html. Separate window, like Preview.app.
function M.open_emacs()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end
    vim.system({ "open", "-a", "Emacs", file })
end

vim.api.nvim_create_user_command("Preview", M.preview_chafa, {})        -- chafa (any terminal)
vim.api.nvim_create_user_command("PreviewImage", M.preview, {})         -- image.nvim (Ghostty only)
vim.api.nvim_create_user_command("PreviewEmacs", M.open_emacs, {})      -- Emacs GUI (crisp)
vim.api.nvim_create_user_command("PreviewExternal", M.open_external, {}) -- native app
vim.api.nvim_create_user_command("PreviewClose", M.close, {})
vim.keymap.set("n", "<leader>vp", M.preview_chafa, { desc = "Preview image/pdf in split (chafa, any terminal)" })
vim.keymap.set("n", "<leader>vi", M.preview, { desc = "Preview via image.nvim (Ghostty only)" })
vim.keymap.set("n", "<leader>vo", M.open_external, { desc = "Preview in native app (browser/Preview/Skim)" })
vim.keymap.set("n", "<leader>ve", M.open_emacs, { desc = "Preview in Emacs GUI (crisp pdf/image)" })
vim.keymap.set("n", "<leader>vP", M.close, { desc = "Close preview split" })

return M
