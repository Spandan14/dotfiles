return {
  "hrsh7th/nvim-cmp",  -- nvim-cmp plugin
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",   -- LSP source for nvim-cmp
    "hrsh7th/cmp-buffer",     -- Buffer completion source
    "hrsh7th/cmp-path",       -- Path completion source
    "saadparwaiz1/cmp_luasnip",  -- Snippet source
    "L3MON4D3/LuaSnip",       -- LuaSnip for snippets
  },
  config = function()
    local cmp = require("cmp")

    -- Setup nvim-cmp with completion sources
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",  -- Customize completion options
      },
      mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = "nvim_lsp" },  -- LSP source
        { name = "buffer" },    -- Buffer source for words in the current buffer
        { name = "path" },      -- Path source for file paths
      },
    })
  end,
}
