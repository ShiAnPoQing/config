return {
  ["<CR>"] = {
    function()
      return vim.fn.pumvisible() == 1 and "<CR>" or "za"
    end,
    "n",
    expr = true,
    desc = "Toggle Fold",
  },
  ["<S-CR>"] = {
    "zMzv",
    "n",
    desc = "Focus current Fold",
  },
}
