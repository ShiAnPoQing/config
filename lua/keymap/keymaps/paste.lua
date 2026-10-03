return {
  ["<M-p>"] = {
    { "<C-g>u<C-r>+", "i" },
    { "<C-r>+", "c" },
    { "<C-w>p", "n", desc = "转到上一个（最后访问的）窗口" },
  },
  -- ["<M-S-p>"] = { "<C-w>P", "n", desc = "转到预览窗口。如果没有预览窗口，这是一个错误" },
  ["<M-space><M-p>"] = {
    { "<C-G>u<C-R><C-o>a", { "i" } },
    { "<C-R>a", { "c" }, { silent = false } },
  },
  ["<M-space><M-space><M-p>"] = {
    { "<C-G>u<C-R><C-O>+", { "i" } },
    { "<C-R>+", "c", { silent = false } },
  },
  -- ["<C-v>"] = {
  --   { "<C-G>u<C-R>+", { "i" } },
  --   { "<C-R>+", { "c" }, { silent = false } },
  -- },
  -- ["<C-S-v>"] = {
  --   { "<C-\\><C-N>pi", "t" },
  -- },
  -- ["<C-space><C-v>"] = { "<C-G>u<C-R>+", { "i" } },
  -- ["<C-space><C-space><C-v>"] = { "<C-G>u<C-R>*", { "i" } },
  --
  -- ["<M-space><M-v>"] = { "<C-G>u<C-R>'", { "i" } },
  -- ["<M-space><M-space><M-v>"] = { "<C-G>u<C-R>*", { "i" } },
}
--map('c', '<C-v>', '<C-R>\'', Opts)
-- { '<C-G>u<C-R><C-o>"', { "i" } },
-- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
--map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
-- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
--map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
--???? 非粘贴模式
