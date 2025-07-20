return {
  ["Y"] = { "y$", { "n" } },
  -- yank/paste/del register
  ["<space>y"] = {
    function()
      require("custom.plugins.copy-register").copy_register("y")
    end,
    { "n", "x" }
  },
  ["<space>Y"] = {
    function()
      require("custom.plugins.copy-register").copy_register("Y")
    end,
    { "n", "x" }
  },
  ["<space>p"] = {
    function()
      require("custom.plugins.paste-register").paste_register("p")
    end,
    { "n", "x" }
  },
  ["<space>P"] = {
    function()
      require("custom.plugins.copy-register").paste_register("P")
    end,
    { "n" }
  },
  ["<space>d"] = {
    function()
      require("custom.plugins.del-register").del_register("d")
    end,
    { "n", "x" }
  },
  -- yank/paste/del Outer register text
  ["<space><space>y"] = { '"+y', { "n", "x" } },
  ["<space><space>Y"] = { '"+Y', { "n", "x" } },
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
    -- { '<C-G>u<C-R><C-o>"', { "i" } },
    { '<C-R>"',        { "c" }, { silent = false } },
    { "<C-\\><C-N>pi", "t" },
  },

  --map('c', '<C-v>', '<C-R>\'', Opts)
  ["<M-space><M-p>"] = {
    { "<C-G>u<C-R><C-o>a", { "i" } },
    { "<C-R>a",            { "c" }, { silent = false } },
  },

  -- 粘贴模式
  ["<M-space><M-space><M-p>"] = {
    { "<C-G>u<C-R><C-O>+", { "i" } },
    { "<C-R>+",            "c",    { silent = false } },
  },

  -- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
  ["<M-space><M-v>"] = { "<C-G>u<C-R>'", { "i" } },
  --map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
  -- 非粘贴模式
  ["<M-space><M-space><M-v>"] = { "<C-G>u<C-R>*", { "i" } },

  -- Map('c', '<C-space><C-v>', '<C-G>u<C-R><C-o>a', Opts)
  ["<C-space><C-v>"] = { "<C-G>u<C-R>'", { "i" } },
  --map('c', '<C-space><C-space><C-v>', '<C-G>u<C-R><C-o>*', Opts)
  -- 非粘贴模式
  ["<C-space><C-space><C-v>"] = { "<C-G>u<C-R>*", { "i" } },
}
