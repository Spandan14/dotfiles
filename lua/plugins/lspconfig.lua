return {
  'neovim/nvim-lspconfig',
  config = function()
    -- 1. Pyright (Python)
    vim.lsp.config('pyright', {
      autostart = true,
    })
    vim.lsp.enable('pyright')

    -- 2. MDX Analyzer
    vim.lsp.config('mdx_analyzer', {
      cmd = { "mdx-language-server", "--stdio" },
      filetypes = { "mdx" }, -- Note: 'mdx' is the standard filetype name
      root_dir = vim.fs.root(0, { "package.json", ".git" }),
      init_options = {
        typescript = {
          enabled = true,
          tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
        },
      },
    })
    vim.lsp.enable('mdx_analyzer')

    -- 3. ESLint (Fixing your config issue)
    vim.lsp.config('eslint', {
      -- This forces the LSP to look for configs at the project root
      root_dir = vim.fs.root(0, { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json" }),
      settings = {
        -- Helps ESLint find the .eslintrc when it's in a subfolder
        workingDirectories = { mode = "auto" },
      },
    })
    vim.lsp.enable('eslint')

    -- require 'lspconfig'.pyright.setup {
    --   autostart = true,
    -- }
    --
    -- require 'lspconfig'.mdx_analyzer.setup {
    --   cmd = { "mdx-language-server", "--stdio" },
    --   filetypes = { ".mdx" },
    --   root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
    --   init_options = {
    --     typescript = {
    --       -- manual path to tsserverlibrary.js folder
    --       enabled = true,
    --       tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    --     },
    --   },
    -- }

    -- require 'lspconfig'.clangd.setup {
    --   cmd = { "clangd", "--compile-commands-dir=out" },
    -- }
  end

}
