-- faster startup: cache compiled Lua modules (bytecode)
vim.loader.enable()

-- Prefer system curl (anaconda's libcurl fails cert verify on some sites,
-- breaking supermaven binary fetch). Shadows only curl, nothing else.
vim.env.PATH = vim.fn.stdpath("config") .. "/bin:" .. vim.env.PATH

require("manishk")

-- hello fem

