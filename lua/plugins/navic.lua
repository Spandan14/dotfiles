return {
  "SmiteshP/nvim-navic",
  config = function()
    local navic = require("nvim-navic")
    navic.setup {
      highlight = true,  -- highlight the text
      separator = " > ", -- separator between symbols
      depth_limit = 0,   -- no limit
    }
  end,
}
