return {
  'Civitasv/cmake-tools.nvim',
  lazy = false,
  config = function()
    vim.api.nvim_create_user_command("CMakeSelectBuildType", function()
      require("cmake-tools").select_build_type()
    end, {})

    vim.keymap.set("n", "<leader>cM", function()
      require("cmake-tools").select_build_target()
    end, { desc = "CMake: Select target" })

    vim.keymap.set("n", "<leader>cm", function()
      require("cmake-tools").select_build_type()
    end, { desc = "CMake: Select build type" })
  end,
}
