return {
  ["Y"] = { "y$", { "n" } },
  -- yank/paste/del A register text
  ["<space>y"] = { '"ay', { "n", "x" } },
  ["<space>p"] = { '"ap', { "n", "x" } },
  ["<space>P"] = { '"aP', { "n" } },
  ["<space>d"] = { '"ad', { "n", "x" } },

  -- yank/paste/del Outer register text
  ["<space><space>y"] = { '"+y', { "n", "x" } },
  ["<space><space>p"] = { '"+p', { "n", "x" } },
  ["<space><space>P"] = { '"+P', { "n", "x" } },
  ["<space><space>d"] = { '"+d', { "n", "x" } },

  --???? 非粘贴模式
  ["<M-p>"] = {
    { '<C-G>u<C-R>"', { "i" } },
    { "<C-W>p",       "n" },
  },
  ["<M-S-p>"] = {
    "<C-w>P",
    "n",
  },

  -- 粘贴模式
  ["<C-v>"] = {
    { '<C-G>u<C-R>"',  { "i" } },
    { '<C-R>"',        { "c" }, { silent = false } },
    { "<C-\\><C-N>pi", "t" },
  },

  --map('c', '<C-v>', '<C-R>\'', Opts)
  ["<M-space><M-p>"] = {
    { "<C-G>u<C-R><C-o>a", { "i" } },
    { "<C-R>a",            { "c" }, { silent = false } },
  },

  -- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
  ["<M-space><M-v>"] = { "<C-G>u<C-R>'", { "i" } },

  -- 粘贴模式
  ["<M-space><M-space><M-p>"] = {
    { "<C-G>u<C-R><C-O>+", { "i" } },
    { "<C-R>+",            "c",    { silent = false } },
  },

  --map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
  -- 非粘贴模式
  ["<M-space><M-space><M-v>"] = { "<C-G>u<C-R>*", { "i" } },
}
