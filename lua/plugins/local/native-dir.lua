return {
  name = "native-dir.nvim",
  condition = function()
    return vim.g.loaded_nvim_dir_plugin ~= 1
  end,
  lazy = false,
  key = {
    ["-"] = {
      "<Plug>(nvim-dir-up)",
      "n",
      ft = { "directory" },
      nowait = true,
    },
    ["b"] = {
      "<Plug>(nvim-dir-vsplit)",
      "n",
      ft = { "directory" },
      nowait = true,
    },
    ["B"] = {
      "<Plug>(nvim-dir-split)",
      "n",
      ft = { "directory" },
      nowait = true,
    },
    ["<bs>"] = {
      "<Plug>(nvim-dir-up)",
      "n",
      ft = { "directory" },
      nowait = true,
    },
    ["<cr>"] = {
      "<Plug>(nvim-dir-open)",
      "n",
      ft = { "directory" },
      nowait = true,
    },
  },
  config = function()
    require("native-dir").setup()
  end,
}
