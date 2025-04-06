return {
  -- 上下移动视图
  ["<C-j>"] = {
    { "<C-y><C-y>",  { "n", "x" } },
    { "<C-O>2<C-y>", { "i" } },
  },
  ["<C-k>"] = {
    { "<C-e><C-e>",  { "n", "x" } },
    { "<C-O>2<C-e>", { "i" } },
  },
  ["<C-h>"] = {
    { "6zh",      { "n", "x" } },
    { "<C-O>6zh", "i" },
  },
  ["<C-l>"] = {
    { "6zl",      { "n", "x" } },
    { "<C-O>6zl", "i" },
  },
  -- 上下左右翻页
  ["<C-S-j>"] = {
    { "<C-f>M",           "n" },
    { "<C-O><C-f><C-O>M", "i" },
    { "<C-f>4<C-y>",      "x" },
  },

  ["<C-S-k>"] = {
    { "<C-b>M",           "n" },
    { "<C-O><C-b><C-O>M", "i" },
    { "<C-b>4<C-e>",      "x" },
  },

  ["<C-S-l>"] = {
    function()
      local count = vim.v.count1
      require("base-function").FilpLeftAndRight("right", count)
      require("repeat").Record(function()
        require("base-function").FilpLeftAndRight("right", count)
      end)
    end,
    { "n", "i", "x" },
  },

  ["<C-S-h>"] = {
    function()
      local count = vim.v.count1
      require("base-function").FilpLeftAndRight("left", count)
      require("repeat").Record(function()
        require("base-function").FilpLeftAndRight("left", count)
      end)
    end,
    { "n", "i", "x" },
  },
  ["<S-ScrollWheelDown>"] = {
    { "zs",      { "n" } },
    { "<C-o>zs", { "i" } },
  },
  ["<S-ScrollWheelUp>"] = {
    { "ze",      { "n" } },
    { "<C-o>ze", { "i" } },
  },
}
