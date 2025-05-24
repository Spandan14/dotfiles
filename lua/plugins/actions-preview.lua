-- Lazy.nvim setup for actions-preview.nvim
return {
  'aznhe21/actions-preview.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' }, -- Ensure you have telescope.nvim as a dependency
  config = function()
    -- Map the code action preview to `gf` in normal and visual mode
    vim.keymap.set({ 'v', 'n' }, '<C-.>', require('actions-preview').code_actions, { desc = 'Preview code actions' })
  end
}
