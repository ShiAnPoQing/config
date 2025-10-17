return {
  -- ["<"] = {
  --   "<gv",
  --   "v",
  --   desc = "< and gv",
  -- },
  -- [">"] = {
  --   ">gv",
  --   "v",
  --   desc = "> and gv",
  -- },
  ["<C-.>"] = {
    "<C-T>",
    "i",
    desc = "Insert one shiftwidth of indent at the start of the current line",
  },
  ["<C-,>"] = {
    "<C-D>",
    "i",
    desc = "Delete one shiftwidth of indent at the start of the current line",
  },
  ["<C-space><C-,>"] = { "0<C-D>", "i", desc = "Delete all indent in the current line" },
  ["<C-space><C-.>"] = { "^<C-D>", "i", desc = "Delete all indent in the current line" },
}
