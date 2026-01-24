return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gb", function()
        require("gitsigns").blame()
      end, { desc = "Git: Blame file" })

      vim.keymap.set("n", "<leader>gl", function()
        require("gitsigns").blame_line()
      end, { desc = "Git: Blame line" })

      vim.keymap.set("n", "<leader>gd", function()
        require("gitsigns").diffthis()
      end, { desc = "Git: Diff this" })
    end
  }
}
