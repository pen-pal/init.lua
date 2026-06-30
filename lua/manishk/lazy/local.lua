local local_plugins = {
	--{
	--    "cockpit",
	--    dir = "~/personal/cockpit",
	--    config = function()
	--        require("cockpit")
	--        vim.keymap.set("n", "<leader>ct", "<cmd>CockpitTest<CR>")
	--        vim.keymap.set("n", "<leader>cr", "<cmd>CockpitRefresh<CR>")
	--    end,
	--},

	--{
	--	"55",
	--	dir = "~/project/self/personal/55",
	--	config = function()
	--		local _55 = require("55")
	--		_55.setup({
	--			name_map = {
	--				un2 = "unnamed_game_1",
	--			},
	--			linear = {
	--				projects = {
	--					unnamed_game_1 = {
	--						team = "Mordoria",
	--						project = "Mordoria",
	--					},
	--				},
	--			},
	--		})
	--		vim.keymap.set("n", "<leader>55", function()
	--			_55.start()
	--		end)
	--		vim.keymap.set("n", "<leader>5t", function()
	--			_55.toggle_diff_lines()
	--		end)
	--		vim.keymap.set("n", "<leader>5r", function()
	--			_55.toggle_diff_lines()
	--			_55.toggle_diff_lines()
	--		end)
	--		vim.keymap.set("n", "<leader>5s", function()
	--			_55.refresh_server()
	--		end)
	--		vim.keymap.set("n", "<leader>5h", function()
	--			_55.home()
	--		end)
	--		vim.keymap.set("n", "<leader>5i", function()
	--			_55.inspect()
	--		end)
	--	end,
	--},
	-- {
	-- 	"the-stru",
	-- 	dir = "~/personal/the-stru",
	-- },

	-- 99 moved to lua/manishk/lazy/ninetynine.lua (now from git, ThePrimeagen/99)
	-- harpoon moved to lua/manishk/lazy/harpoon.lua (now from git, branch harpoon2)
}

return local_plugins
