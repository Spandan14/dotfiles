return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- local actions = require('telescope.actions')
    -- local builtin = require('telescope.builtin')

    -- Define a custom delete action for Telescope
    local delete_action = function(prompt_bufnr)
      local selected_entry = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
      local file_to_delete = selected_entry.path

      -- Ask for confirmation before deleting the file
      local confirmation = vim.fn.confirm('Are you sure you want to delete this file?', '&Yes\n&No', 2)
      if confirmation == 1 then
        os.remove(file_to_delete) -- Delete the file
        print('Deleted: ' .. file_to_delete)
      else
        print('File deletion cancelled.')
      end
    end

    -- Load the file_browser extension (if you are using it)
    require("telescope").load_extension("file_browser")

    -- Map key to open the file_browser extension
    vim.keymap.set('n', '<leader>ff', function()
      -- local ok = pcall(require("telescope.builtin").resume)
      require("telescope").extensions.file_browser.file_browser({
        -- cwd = vim.fn.expand(":%:p"),
        hidden = true
      })
    end, { desc = "Find Files" })

    vim.keymap.set('n', '<leader>fr', function()
      require("telescope.builtin").resume()
    end, { desc = "Resume Find Files" })

    vim.keymap.set("n", "<leader>fg", function()
      require("telescope.builtin").live_grep({
        additional_args = function()
          return { "--hidden", "--no-ignore" }
        end
      })
    end, { desc = "Live grep including hidden files" })

    vim.keymap.set("n", "<leader>uu", function()
      require("telescope.builtin").lsp_references({
        layout_strategy = "horizontal",
        show_line = false,
        include_declaration = true,
        initial_mode = "normal",
        ignore_filename = false,
      })
    end, { desc = "Find usages" })

    -- Map delete action to `dd` in Telescope only (find_files picker)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopePrompt',
      callback = function()
        -- Map `dd` only in Telescope find_files
        vim.keymap.set('n', 'dd', delete_action, { buffer = 0, desc = "Delete file" })
      end
    })
  end,
}
