return {
  ["<C-space><C-v>"] = {
    '<C-\\><C-N>"api',
    "t",
    silent = false,
    noremap = true,
  },
  ["<C-space><C-space><C-v>"] = {
    '<C-\\><C-N>"+pi',
    "t",
    silent = false,
    noremap = true,
  },
  ["<M-`><M-h>"] = { "<home>", "t" },
  ["<M-`><M-l>"] = { "<end>", "t" },
  ["<Esc>"] = {
    "<C-\\><C-N>",
    "t",
  },
}
