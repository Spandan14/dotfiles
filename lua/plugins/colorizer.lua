return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "*", -- Enable for all filetypes
    }, { mode = "background" }) -- Set color mode
  end
}
