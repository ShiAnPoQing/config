return {
  ["<C-j>"] = {
    { "<C-y><C-y>", { "n", "x" } },
    { "<C-O>2<C-y>", { "i" } },
    silent = true,
  },
  ["<C-k>"] = {
    { "<C-e><C-e>", { "n", "x" } },
    { "<C-O>2<C-e>", { "i" } },
    silent = true,
  },
  ["<C-h>"] = {
    { "6zh", { "n", "x" } },
    { "<C-O>6zh", "i" },
    silent = true,
  },
  ["<C-l>"] = {
    { "6zl", { "n", "x" } },
    { "<C-O>6zl", "i" },
    silent = true,
  },
  ["<C-S-j>"] = {
    { "<C-f>M", "n" },
    { "<C-O><C-f><C-O>M", "i" },
    { "<C-f>M", "x" },
    silent = true,
  },
  ["<C-S-k>"] = {
    { "<C-b>M", "n" },
    { "<C-O><C-b><C-O>M", "i" },
    { "<C-b>M", "x" },
    silent = true,
  },
  ["<C-S-l>"] = {
    {
      "zLgm",
      { "n", "x" },
    },
    {
      "<Esc>zLgma",
      "i",
    },
    silent = true,
  },
  ["<C-S-h>"] = {
    {
      "zHgm",
      { "n", "x" },
    },
    {
      "<Esc>zHgma",
      "i",
    },
    silent = true,
  },
  ["<S-ScrollWheelDown>"] = {
    { "zs", { "n" } },
    { "<C-o>zs", { "i" } },
    silent = true,
  },
  ["<S-ScrollWheelUp>"] = {
    { "ze", { "n" } },
    { "<C-o>ze", { "i" } },
    silent = true,
  },
}
