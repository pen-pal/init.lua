return {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Spectre",
    keys = {
        { "<leader>F", function() require("spectre").toggle() end, desc = "Spectre (project find/replace)" },
    },
    config = function()
        require("spectre").setup()
    end,
}
