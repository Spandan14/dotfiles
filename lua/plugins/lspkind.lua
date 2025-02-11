return {
  "onsails/lspkind-nvim",
  lazy = false,  -- Ensure lspkind loads at startup
  config = function()
    -- Import the lspkind module
    local lspkind = require('lspkind')

    -- Configure nvim-cmp to use lspkind for completion
    require("cmp").setup({
      formatting = {
        format = lspkind.cmp_format({
          with_text = true,  -- Show text and icons in completion menu
          menu = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            path = "[Path]",
            calc = "[Calc]",
            nvim_lua = "[API]",
          },
        }),
      },
    })

    -- Use lspkind for hover tooltips with rounded borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",  -- Make the hover window rounded
    })
  end,
}

