-- Neovide GUI settings. Only applied when running inside Neovide (`neovide`),
-- ignored in a terminal. Uses `guifont` (Neovide's font knob) and matches the
-- Ghostty Nord/transparency vibe.
if not vim.g.neovide then
    return
end

-- font (Neovide uses guifont, not the terminal font)
vim.o.guifont = "Hack Nerd Font Mono:h14"

-- look — match Ghostty (transparent-ish, padded)
vim.g.neovide_opacity = 0.95
vim.g.neovide_normal_opacity = 0.95
vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_window_blurred = true

-- smooth animations (the buttery feel)
vim.g.neovide_position_animation_length = 0.15
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_cursor_vfx_mode = "railgun" -- particle trail; "" to disable
vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 5

-- behavior
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_input_macos_option_key_is_meta = "only_left" -- left ⌥ = Meta (<M-…> maps)

-- macOS-native font scaling: ⌘= / ⌘- / ⌘0
local function scale(by)
    vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) * by
end
vim.keymap.set("n", "<D-=>", function() scale(1.1) end, { desc = "Neovide: zoom in" })
vim.keymap.set("n", "<D-->", function() scale(1 / 1.1) end, { desc = "Neovide: zoom out" })
vim.keymap.set("n", "<D-0>", function() vim.g.neovide_scale_factor = 1 end, { desc = "Neovide: reset zoom" })

-- macOS-native clipboard: ⌘C / ⌘V
vim.keymap.set({ "n", "v" }, "<D-c>", '"+y', { desc = "Copy (cmd+c)" })
vim.keymap.set({ "n", "v" }, "<D-v>", '"+p', { desc = "Paste (cmd+v)" })
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste (cmd+v)" })
vim.keymap.set("c", "<D-v>", "<C-r>+", { desc = "Paste (cmd+v)" })
