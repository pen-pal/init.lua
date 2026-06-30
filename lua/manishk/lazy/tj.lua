return {
    "tjdevries/php.nvim",
    ft = "php", -- only load for PHP files (was loading ~35ms at every startup)
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        require("php").setup({})
    end
}
