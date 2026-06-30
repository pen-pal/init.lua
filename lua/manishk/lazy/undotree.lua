
return {
    "mbbill/undotree",
    keys = { "<leader>u" },
    cmd = { "UndotreeToggle", "UndotreeShow" },

    config = function() 
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}

