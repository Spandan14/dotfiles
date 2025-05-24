return {
  'nanozuki/tabby.nvim',
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
  -- Keymaps for Tabby.nvim
    vim.keymap.set('n', '<leader>tt', '<cmd>TabbyNew<CR>', { desc = 'New Tab' })  -- Open new tab
    vim.keymap.set('n', '<leader>tq', '<cmd>TabbyClose<CR>', { desc = 'Close Tab' })  -- Close current tab
    vim.keymap.set('n', '<leader>tn', '<cmd>TabbyNext<CR>', { desc = 'Next Tab' })  -- Go to next tab
    vim.keymap.set('n', '<leader>tp', '<cmd>TabbyPrev<CR>', { desc = 'Previous Tab' })  -- Go to previous tab

    -- Split tab keybindings
    vim.keymap.set('n', '<leader>hs', '<cmd>split<CR>', { desc = 'Horizontal Split' })  -- Horizontal split
    vim.keymap.set('n', '<leader>vs', '<cmd>vsplit<CR>', { desc = 'Vertical Split' })  -- Vertical split

    -- Resize splits
    vim.keymap.set('n', '<leader>+s', '<cmd>resize +5<CR>', { desc = 'Increase Split Size' })  -- Increase size of split
    vim.keymap.set('n', '<leader>-s', '<cmd>resize -5<CR>', { desc = 'Decrease Split Size' })  -- Decrease size of split
 
  end,
}
