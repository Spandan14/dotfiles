return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = false, -- Disable transparency
                    dim_inactive = false, -- Don't dim inactive windows
                    terminal_colors = true, -- Enable terminal colors
                },
            })
            vim.cmd("colorscheme carbonfox") -- Apply the colorscheme
        end,
    },
}

