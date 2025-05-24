return {
    "github/copilot.vim",
    lazy = false,  -- Ensure Copilot loads at startup
    config = function()
      vim.g.copilot_enabled = true
      vim.g.copilot_filetypes = {
        ["*"] = true,  -- Enable for all file types
      }
    end
}

