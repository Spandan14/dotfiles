require("config.lazy")
-- Neovim Settings (General) vim.opt.tabstop = 4           -- Set tabstop to 4 spaces vim.opt.shiftwidth = 4        -- Set shiftwidth to 4 spaces
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

-- 1. Handle MDX Analyzer
vim.lsp.config('mdx_analyzer', {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx" },
  -- Note: We use the built-in root_pattern if available,
  -- or a simple function to keep it independent of lspconfig.util
  root_dir = vim.fs.root(0, { "package.json", ".git" }),
  init_options = {
    typescript = {
      enabled = true,
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    },
  },
})
vim.lsp.enable('mdx_analyzer')

-- 2. Handle LALRPOP LSP
local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/packages/lalrpop-lsp/bin/lalrpop-lsp")

vim.lsp.config('lalrpop_lsp', {
  install = {
    -- This keeps the definition clear without needing the old 'configs' table
    cmd = { mason_bin },
  },
  filetypes = { "lalrpop" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".git" }) or vim.fs.dirname(fname)
  end,
})
vim.lsp.enable('lalrpop_lsp')

-- 3. Ensure ESLint is enabled (to fix your original issue)
vim.lsp.config('eslint', {
  -- Explicitly defining the root directory helps with .eslintrc detection
  root_dir = vim.fs.root(0, { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", "eslint.config.js" }),
  settings = {
    workingDirectories = { mode = "auto" },
  }
})
vim.lsp.enable('eslint')


-- require("lspconfig").mdx_analyzer.setup {
--   cmd = { "mdx-language-server", "--stdio" },
--   filetypes = { "mdx" },
--   root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
--   init_options = {
--     typescript = {
--       -- manual path to tsserverlibrary.js folder
--       enabled = true,
--       tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
--     },
--   },
-- }
--
--
-- local lspconfig = require("lspconfig")
-- local configs = require("lspconfig.configs")
--
-- -- full path to the LALRPOP LSP binary
-- local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/packages/lalrpop-lsp/bin/lalrpop-lsp")
--
-- -- register the server if not already present
-- if not configs.lalrpop_lsp then
--   configs.lalrpop_lsp = {
--     default_config = {
--       cmd = { mason_bin },
--       filetypes = { "lalrpop" },
--       root_dir = function(fname)
--         return lspconfig.util.find_git_ancestor(fname)
--             or lspconfig.util.path.dirname(fname)
--       end,
--     },
--   }
-- end
--
-- lspconfig.lalrpop_lsp.setup({})

require("mason").setup()
require("mason-lspconfig").setup()

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.v",
  command = "set filetype=verilog"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "mdx"
    -- vim.cmd("setlocal syntax=markdown")
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.lalrpop",
  callback = function()
    vim.bo.filetype = "lalrpop"
  end,
})

-- Create an autocmd group
vim.api.nvim_create_augroup("FiletypeIndent", { clear = true })

-- Set 4-space indent for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = "FiletypeIndent",
  pattern = { "python", "cpp", "c", "h" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

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

local navic = require("nvim-navic")

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

local navic = require("nvim-navic")

-- Auto-attach navic to any buffer with an LSP
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client.server_capabilities.documentSymbolProvider then
--       navic.attach(client, args.buf)
--     end
--   end,
-- })

-- Auto-update lualine whenever navic attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, args.buf)
      vim.cmd("redrawtabline") -- force lualine to refresh
      vim.cmd("redrawstatus")  -- optional, also refresh statusline
    end
  end,
})

local function hide_git_blame() return vim.fn.winwidth(0) > 150 end

require('lualine').setup({
  options = {
    theme = 'auto',
    icons_enabled = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
  },
  sections = {
    lualine_a = { 'mode' },     -- Vim mode (NORMAL, INSERT, etc.)
    lualine_b = { 'branch' },   -- Git branch
    lualine_c = {
      { 'filename', path = 1 }, -- Shows relative path
      {
        function() return navic.get_location({ separator = '  ' }) end,
        cond = function() return navic.is_available() end,
      },
      'diagnostics', -- LSP or linter errors, warnings, hints
    },
    lualine_x = {
      { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available and hide_git_blame },
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

local osys = require("cmake-tools.osys")
require("cmake-tools").setup {
  cmake_command = "cmake",                                          -- this is used to specify cmake command path
  ctest_command = "ctest",                                          -- this is used to specify ctest command path
  cmake_use_preset = true,
  cmake_regenerate_on_save = true,                                  -- auto generate when save CMakeLists.txt
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
  cmake_build_options = {},                                         -- this will be passed when invoke `CMakeBuild`
  -- support macro expansion:
  --       ${kit}
  --       ${kitGenerator}
  --       ${variant:xx}
  cmake_build_directory = function()
    if osys.iswin32 then
      return "out\\${variant:buildType}"
    end
    return "out/${variant:buildType}"
  end,                    -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
  cmake_compile_commands_options = {
    action = "soft_link", -- available options: soft_link, copy, lsp, none
    -- soft_link: this will automatically make a soft link from compile commands file to target
    -- copy:      this will automatically copy compile commands file to target
    -- lsp:       this will automatically set compile commands file location using lsp
    -- none:      this will make this option ignored
    target = vim.loop.cwd()                  -- path to directory, this is used only if action == "soft_link" or action == "copy"
  },
  cmake_kits_path = nil,                     -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
  cmake_variants_message = {
    short = { show = true },                 -- whether to show short message
    long = { show = true, max_length = 40 }, -- whether to show long message
  },
  cmake_dap_configuration = {                -- debug settings for cmake
    name = "cpp",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = true,
    console = "integratedTerminal",
  },
  cmake_executor = {                    -- executor to use
    name = "quickfix",                  -- name of the executor
    opts = {},                          -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
    default_opts = {                    -- a list of default and possible values for executors
      quickfix = {
        show = "always",                -- "always", "only_on_error"
        position = "belowright",        -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
        size = 10,
        encoding = "utf-8",             -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
        auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
      },
      toggleterm = {
        direction = "float",   -- 'vertical' | 'horizontal' | 'tab' | 'float'
        close_on_exit = false, -- whether close the terminal when exit
        auto_scroll = true,    -- whether auto scroll to the bottom
        singleton = true,      -- single instance, autocloses the opened one, if present
      },
      overseer = {
        new_task_opts = {
          strategy = {
            "toggleterm",
            direction = "horizontal",
            auto_scroll = true,
            quit_on_exit = "success"
          }
        }, -- options to pass into the `overseer.new_task` command
        on_new_task = function(task)
          require("overseer").open(
            { enter = false, direction = "right" }
          )
        end, -- a function that gets overseer.Task when it is created, before calling `task:start`
      },
      terminal = {
        name = "Main Terminal",
        prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
        split_direction = "horizontal", -- "horizontal", "vertical"
        split_size = 11,

        -- Window handling
        single_terminal_per_instance = true,  -- Single viewport, multiple windows
        single_terminal_per_tab = true,       -- Single viewport per tab
        keep_terminal_static_location = true, -- Static location of the viewport if avialable
        auto_resize = true,                   -- Resize the terminal if it already exists

        -- Running Tasks
        start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
        focus = false,              -- Focus on terminal when cmake task is launched.
        do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
      },                            -- terminal executor uses the values in cmake_terminal
    },
  },
  cmake_runner = {               -- runner to use
    name = "terminal",           -- name of the runner
    opts = {},                   -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
    default_opts = {             -- a list of default and possible values for runners
      quickfix = {
        show = "always",         -- "always", "only_on_error"
        position = "belowright", -- "bottom", "top"
        size = 10,
        encoding = "utf-8",
        auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
      },
      toggleterm = {
        direction = "float",   -- 'vertical' | 'horizontal' | 'tab' | 'float'
        close_on_exit = false, -- whether close the terminal when exit
        auto_scroll = true,    -- whether auto scroll to the bottom
        singleton = true,      -- single instance, autocloses the opened one, if present
      },
      terminal = {
        name = "Main Terminal",
        prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
        split_direction = "horizontal", -- "horizontal", "vertical"
        split_size = 11,

        -- Window handling
        single_terminal_per_instance = true,  -- Single viewport, multiple windows
        single_terminal_per_tab = true,       -- Single viewport per tab
        keep_terminal_static_location = true, -- Static location of the viewport if avialable
        auto_resize = true,                   -- Resize the terminal if it already exists

        -- Running Tasks
        start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
        focus = false,              -- Focus on terminal when cmake task is launched.
        do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
      },
    },
  },
  cmake_notifications = {
    runner = { enabled = true },
    executor = { enabled = true },
    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
    refresh_rate_ms = 100, -- how often to iterate icons
  },
  cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
  cmake_use_scratch_buffer = false, -- A buffer that shows what cmake-tools has done
}
