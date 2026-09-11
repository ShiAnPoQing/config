return {
  --- Nvim buitin: <C-w><C-w> Same as <C-w>w, see |CTRL-W_w|
  --- My choice: <C-w><C-w> used to a new leader key
  --- NOTE: breaking change
  ["<C-w><C-w>"] = { "<nop>", { "n", "x" } },

  ["<C-w>="] = {
    function()
      require("builtin.maximize-window").equal_size()
    end,
    { "n", "x" },
    desc = 'Same as "CTRL-W =", but allows restoring the layout before "CTRL-W ="',
  },
  ["<C-w>|"] = {
    function()
      require("builtin.maximize-window").max_width()
    end,
    { "n", "x" },
    desc = 'Same as "CTRL-W |", but allows restoring the layout before "CTRL-W |"',
  },
  ["<C-w>_"] = {
    function()
      require("builtin.maximize-window").max_height()
    end,
    { "n", "x" },
    desc = 'Same as "CTRL-W _", but allows restoring the layout before "CTRL-W _"',
  },
  ["<C-w>m"] = {
    function()
      require("builtin.maximize-window").max_size()
    end,
    { "n", "x" },
    desc = 'Same as "CTRL-W | CTRL-W _", but allows restoring the layout before "CTRL-W | CTRL-W _"',
  },
  ["<C-w><C-m>"] = {
    function()
      require("builtin.maximize-window").max_size()
    end,
    { "n", "x" },
    desc = 'Same as "CTRL-W | CTRL-W _", but allows restoring the layout before "CTRL-W | CTRL-W _"',
  },
  -- ["<M-v>"] = {
  --   "<cmd>vsplit<cr>",
  --   "n",
  -- },
  -- ["<M-S-V>"] = {
  --   "<cmd>split<cr>",
  --   "n",
  -- },
  -- ["<M-=>"] = { "<C-w>=", "n" },
  -- ["<M-n>"] = { "<C-w>n", "n" },
  -- ["<space><C-M-n>"] = {
  --   function()
  --     vim.api.nvim_exec2(
  --       [[
  --   vsplit
  --   e n
  --   ]],
  --       {}
  --     )
  --   end,
  --   "n",
  -- },
  -- ["<C-M-space><C-M-n>"] = {
  --   -- function()
  --   --   vim.api.nvim_exec2(
  --   --     [[
  --   -- vsplit
  --   -- e n
  --   -- ]],
  --   --     {}
  --   --   )
  --   -- end,
  --   -- "n",
  -- },
  -- ["<M-q>"] = {
  --   "<C-w>q",
  --   "n",
  --   desc = "Quit current window",
  -- },
  -- ["<M-=>"] = {
  --   function()
  --     require("builtin.window-resize").resize("increase", "horizontal")
  --   end,
  --   "n",
  -- },
  -- ["<M-->"] = {
  --   function()
  --     require("builtin.window-resize").resize("decrease", "horizontal")
  --   end,
  --   "n",
  -- },
  ["<M-space><M-k>"] = {
    "<C-w>K",
    { "n", "x" },
    desc = "Move the current window to be at the very top, using the full width of the screen",
  },
  ["<M-space><M-j>"] = {
    "<C-w>J",
    { "n", "x" },
    desc = "Move the current window to be at the very bottom, using the full width of the screen",
  },
  ["<M-space><M-h>"] = {
    "<C-w>H",
    { "n", "x" },
    desc = "Move the current window to be at the far left, using the full height of the screen",
  },
  ["<M-space><M-l>"] = {
    "<C-w>L",
    { "n", "x" },
    desc = "Move the current window to be at the far right, using the full height of the screen",
  },

  --- Window Switching
  ["<C-w><C-w>h"] = { "10<C-w>h", { "n", "x" }, desc = "Goto the leftmost window" },
  ["<C-w><C-w><C-h>"] = { "10<C-w>h", { "n", "x" }, desc = "Goto the leftmost window" },
  ["<C-w><C-w>l"] = { "10<C-w>l", { "n", "x" }, desc = "Goto the rightmost window" },
  ["<C-w><C-w><C-l>"] = { "10<C-w>l", { "n", "x" }, desc = "Goto the rightmost window" },
  ["<C-w><C-w>k"] = { "10<C-w>k", { "n", "x" }, desc = "Goto the topmost window" },
  ["<C-w><C-w><C-k>"] = { "10<C-w>k", { "n", "x" }, desc = "Goto the topmost window" },
  ["<C-w><C-w>j"] = { "10<C-w>j", { "n", "x" }, desc = "Goto the bottommost window" },
  ["<C-w><C-w><C-j>"] = { "10<C-w>j", { "n", "x" }, desc = "Goto the bottommost window" },
  -- Close window
  ["<C-w>C"] = { "<cmd>close!<cr>", { "n", "x" }, desc = ":close!" },
  -- Close floating window
  ["<C-w><C-w>c"] = { "<cmd>fclose<cr>", { "n", "x" }, desc = ":fclose" },
  ["<C-w><C-w>C"] = { "<cmd>fclose!<cr>", { "n", "x" }, desc = ":fclose!" },

  -- Window movement
  -- NOTE: breaking change
  -- Nvim builtin: |CTRL-W_H| 将当前窗口移动到最左边
  -- My choice: buffer swap
  --            <C-W>H 将当前窗口 buffer 与左边窗口 buffer 交换
  --            <C-W><C-W>H 将当前窗口与最左边窗口交换
  --- see  .config/nvim/pack/custom/opt/buffer-swap
  -- ["<C-w>H"] = { },
  -- ["<C-w>L"] = { },
  -- ["<C-w>J"] = { },
  -- ["<C-w>K"] = { },
  -- ["<C-w><C-w>H"] = { },
  -- ["<C-w><C-w>L"] = { },
  -- ["<C-w><C-w>J"] = { },
  -- ["<C-w><C-w>K"] = { },
}
