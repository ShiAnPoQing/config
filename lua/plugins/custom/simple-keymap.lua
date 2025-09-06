return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/simple-keymap.nvim",
  name = "simple-keymap",
  config = function()
    require("simple-keymap").setup({
      add = {
        "keymaps/",
        "keymaps/select-mode",
        "test",
      },
      del = {
        ["w"] = { "n" },
      },
    })

    vim.api.nvim_create_autocmd("BufReadPre", {
      pattern = "*",
      callback = function()
        pcall(vim.keymap.del, "x", "in")
        pcall(vim.keymap.del, "n", "d0i")
        pcall(vim.keymap.del, "n", "d0o")
        pcall(vim.keymap.del, "n", "ds>")
        pcall(vim.keymap.del, "n", "ds<")
        pcall(vim.keymap.del, "n", 'ds"')
        pcall(vim.keymap.del, "n", "ds'")
        pcall(vim.keymap.del, "n", "ds}")
        pcall(vim.keymap.del, "n", "ds{")
        pcall(vim.keymap.del, "n", "ds[")
        pcall(vim.keymap.del, "n", "ds]")
        pcall(vim.keymap.del, "n", "ds(")
        pcall(vim.keymap.del, "n", "ds)")
      end,
    })
  end,
}
