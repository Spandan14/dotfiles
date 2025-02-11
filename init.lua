require("config.lazy")
-- Neovim Settings (General)
vim.opt.tabstop = 4          -- Set tabstop to 4 spaces
vim.opt.shiftwidth = 4       -- Set shiftwidth to 4 spaces
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

vim.api.nvim_set_option("clipboard", "unnamed")

-- forge
vim.filetype.add({
  extension = {
    frg = "forge",  -- Just directly assign the filetype to "forge"
    ["tests.frg"] = "forge",  -- Just directly assign the filetype to "forge"
  },
})

-- Optionally, set a custom comment string
vim.api.nvim_create_autocmd("FileType", {
  pattern = "forge",
  callback = function()
    vim.opt.commentstring = "// %s"  -- Set commentstring for forge files
  end,
})

-- FORGE SETUP INSTRUCTIONS FOR LAZY.NVIM
-- COPY `highlights.scm` to `~/.local/share/nvim/lazy/nvim-treesitter/queries/forge`
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.forge = {
  install_info = {
    url = "~/.config/nvim/lua/projects/forge-lsp", 
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
  },
  filetype = "frg", -- if filetype does not match the parser name
}

vim.treesitter.language.register("forge", "frg")


-- Enable Treesitter for Forge
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "forge" },
  highlight = {
    enable = true,
  },
}

vim.api.nvim_set_hl(0, "@operator", { fg = "#c678dd" })
vim.api.nvim_set_hl(0, "@delimiter", { fg = "#c678dd" })

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

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    lspconfig[server_name].setup {}
  end,
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })


-- Enable diagnostics globally
vim.diagnostic.config({
  virtual_text = true,  -- Show inline diagnostics
  signs = true,         -- Show signs in the gutter (e.g., the error icon)
  underline = true,     -- Underline errors/warnings
  update_in_insert = false,  -- Don't update diagnostics while typing
})

-- Add keybindings for diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })


-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
