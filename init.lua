require("config.lazy")
-- Neovim Settings (General)
vim.opt.tabstop = 4           -- Set tabstop to 4 spaces
vim.opt.shiftwidth = 4        -- Set shiftwidth to 4 spaces
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

vim.api.nvim_set_option("clipboard", "unnamed")

-- forge
vim.filetype.add({
  extension = {
    frg = "forge",           -- Just directly assign the filetype to "forge"
    ["tests.frg"] = "forge", -- Just directly assign the filetype to "forge"
  },
})

-- Optionally, set a custom comment string
vim.api.nvim_create_autocmd("FileType", {
  pattern = "forge",
  callback = function()
    vim.opt.commentstring = "// %s" -- Set commentstring for forge files
  end,
})

-- FORGE SETUP INSTRUCTIONS FOR LAZY.NVIM
-- COPY `highlights.scm` to `~/.local/share/nvim/lazy/nvim-treesitter/queries/forge`
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.forge = {
  install_info = {
    url = "~/.config/nvim/lua/projects/forge-lsp",
    files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main",            -- default branch in case of git repo if different from master
  },
  filetype = "frg",             -- if filetype does not match the parser name
}

vim.treesitter.language.register("forge", "frg")


-- Enable Treesitter for Forge
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "forge" },
  highlight = {
    enable = true,
  },
}

vim.api.nvim_set_hl(0, "@operator", { fg = "#c678dd" })
vim.api.nvim_set_hl(0, "@delimiter", { fg = "#c678dd" })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "#ff9e64", italic = true })

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
-- require("telescope").setup {
--   extensions = {
--     file_browser = {
--       theme = "ivy",
--       -- disables netrw and use telescope-file-browser in its place
--       hijack_netrw = true,
--     },
--   },
-- }
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"

require("mason").setup()
require("mason-lspconfig").setup()

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.v",
  command = "set filetype=verilog"
})

-- local lspconfig = require("lspconfig")

-- Rename the variable under the cursor using LSP
vim.api.nvim_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
-- lspconfig.gopls.setup({
--   on_attach = function(client, bufnr)
--    if vim.g.config.use_winbar == true then
--       navic.attach(client, bufnr)
--     end
--     if client.name == 'gopls' then
--       client.server_capabilities.semanticTokensProvider = {
--         full = true,
--         legend = {
--           tokenTypes = { 'namespace', 'type', 'class', 'enum', 'interface', 'struct', 'typeParameter', 'parameter', 'variable', 'property', 'enumMember', 'event', 'function', 'method', 'macro', 'keyword', 'modifier', 'comment', 'string', 'number', 'regexp', 'operator', 'decorator' },
--           tokenModifiers = { 'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async', 'modification', 'documentation', 'defaultLibrary'}
--         }
--       }
--     end
--   end
-- })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })


-- Enable diagnostics globally
vim.diagnostic.config({
  virtual_text = true,      -- Show inline diagnostics
  signs = true,             -- Show signs in the gutter (e.g., the error icon)
  underline = true,         -- Underline errors/warnings
  update_in_insert = false, -- Don't update diagnostics while typing
})

-- Add keybindings for diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })


-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

-- autopairs
require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    html = { "html" },                                            -- Enable for HTML (you can add other languages as needed)
    javascript = { "jsx", "javascriptreact", "typescriptreact" }, -- Enable for JSX/TSX
  }
})

-- copilot bindings
vim.keymap.set("i", "<C-j>", function() return vim.fn["copilot#Accept"]() end, { expr = true, silent = true })

-- toggleterm
vim.o.hidden = true
require("toggleterm").setup({
  direction = 'float',
  open_mapping = [[<c-\>]],
})

-- spelling
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- only in text buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "TelescopePrompt", "NvimTree", "help", "qf", "terminal",  -- Common plugin buffers
    "Lazy", "mason", "packer", "toggleterm", "spectre_panel", -- Plugin UIs
    "alpha", "dashboard", "lir", "Outline", "NeogitStatus", "Trouble",
    "noice", "notify", "dapui_scopes", "dapui_watches", "dapui_stacks",
    "dapui_breakpoints", "dapui_console", "dap-repl"
  },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- mini animate
require('mini.animate').setup({
  scroll = { timing = function() return 2 end },
  resize = { timing = function() return 2 end },
  open = { timing = function() return 2 end },
  close = { timing = function() return 2 end },
})

-- lualine
local git_blame = require('gitblame')
-- This disables showing of the blame text next to the cursor
vim.g.gitblame_display_virtual_text = 0

require('lualine').setup({
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },     -- Vim mode (NORMAL, INSERT, etc.)
    lualine_b = { 'branch' },   -- Git branch
    lualine_c = {
      { 'filename', path = 1 }, -- Shows relative path
      'diagnostics'             -- LSP or linter errors, warnings, hints
    },
    lualine_x = {
      { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
    },
    lualine_y = { 'progress' }, -- Shows file progress (e.g., 42%)
    lualine_z = { 'location' }  -- Shows line:column position
  }
})

-- actions-preview.nvim configuration
vim.api.nvim_set_keymap("n", "<leader>tt", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tq", ":tabclose<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gTab", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gT", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
-- Open a new tab in a horizontal split
vim.api.nvim_set_keymap("n", "<leader>ths", ":split<CR>", { noremap = true, silent = true })

-- Open a new tab in a vertical split
vim.api.nvim_set_keymap("n", "<leader>tvs", ":vsplit<CR>", { noremap = true, silent = true })

-- open diagnostic float
vim.api.nvim_set_keymap("n", "<leader>dd", ":lua vim.diagnostic.open_float(0, { scope = 'line' })<CR>",
  { noremap = true, silent = true })

-- open usagesinit
-- vim.api.nvim_set_keymap("n", "<leader>uu", ":lua vim.lsp.buf.references()<CR>",
--   { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "]g", ":lua vim.diagnostic.goto_next({ wrap = true })<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[g", ":lua vim.diagnostic.goto_prev({ wrap = true })<CR>",
  { noremap = true, silent = true })

-- conform
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  }
})

-- actions preview setup part 2
local hl = require("actions-preview.highlight")
require("actions-preview").setup({
  highlight_command = {
    hl.delta("delta --side-by-side --paging=never --no-gitconfig"),
  },
})

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell,
    require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim

    -- ESLint diagnostics + code actions + formatting (if you want)
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.eslint,
  },
  debug = true,
})
