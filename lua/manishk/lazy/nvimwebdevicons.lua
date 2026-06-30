return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  priority = 1000,
  config = function()
    local devicons = require("nvim-web-devicons")

    devicons.setup {
      color_icons = true,
      override = {
        html = { icon = "", color = "#ff6d4a", name = "html" },
        css  = { icon = "", color = "#42a5f5", name = "css" },
        js   = { icon = "", color = "#ffe14d", name = "js" },
        ts   = { icon = "ﯤ", color = "#5fafff", name = "ts" },
        kt   = { icon = "󱈙", color = "#ffab40", name = "kt" },
        py   = { icon = "", color = "#ffd75f", name = "py" },
        json = { icon = "", color = "#ffd75f", name = "json" },
        yaml = { icon = "", color = "#87d7ff", name = "yaml" },
        md   = { icon = "", color = "#87afff", name = "md" },
        sh   = { icon = "", color = "#a3ff5f", name = "sh" },
        default = { icon = "󰈙", color = "#e0e0e0", name = "default" },
      }
    }

    -- Brighten more filetypes by reusing their existing glyph, just swapping
    -- in a vivid color. Keeps default icons, only recolors.
    local brighter = {
      lua  = "#5fd7ff",
      rb   = "#ff5f87",
      ru   = "#ff5f87",
      erb  = "#ff7a93",
      yml  = "#87d7ff",
      toml = "#ffaf5f",
      go   = "#5fffff",
      rs   = "#ffaf5f",
      jsx  = "#ffe14d",
      tsx  = "#5fafff",
      vue  = "#42ff8f",
      sql  = "#ff8787",
      vim  = "#87ff5f",
      lock = "#c0c0c0",
      conf = "#cad3f5",
      env  = "#ffd75f",
      txt  = "#cad3f5",
      sample = "#cad3f5",
      properties = "#87d7ff",
      gitignore = "#ff7a6b",
    }
    for ext, color in pairs(brighter) do
      local icon = devicons.get_icon("file." .. ext, ext, { default = true })
      if icon then
        devicons.set_icon({ [ext] = { icon = icon, color = color, name = ext } })
      end
    end
  end
}
