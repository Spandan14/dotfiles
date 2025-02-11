
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Setup Telescope with floating window layout configuration
        -- require("telescope").setup{
        --     defaults = {
        --         layout_strategy = "center",  -- Use 'floating' layout for absolute control
        --         layout_config = {
        --             width = 0.8,  -- 80% of screen width
        --             height = 0.8,  -- 80% of screen height
        --             prompt_position = "top",  -- Keep prompt at the top
        --         },
        --         border = true,  -- Add a border around the floating window
        --         borderchars = { '─', '│', '─', '│', '┌', '┐', '└', '┘' },
        --     },
        --     extensions = {
        --         file_browser = {
        --             -- File browser-specific configurations, if any
        --         }
        --     }
        -- }

        -- Load the file_browser extension (if you are using it)
        require("telescope").load_extension("file_browser")

        -- Map key to open the file_browser extension
        vim.keymap.set('n', '<leader>ff', function()
            require("telescope").extensions.file_browser.file_browser()
        end, { desc = "Find Files" })
    end,
}
