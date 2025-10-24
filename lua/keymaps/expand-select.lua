return {
  ["<M-space><M-o>"] = {
    "<C-G>w<C-G>",
    "s",
    desc = "Word start(forward)",
  },
  ["<M-space><M-i>"] = {
    "<C-G>ge<C-G>",
    "s",
    desc = "Word end(backward)",
  },
  ["<M-o>"] = {
    "<C-G>e<C-G>",
    "s",
    desc = "Word end(forward)",
  },
  ["<M-i>"] = {
    "<S-left>",
    "s",
    desc = "Word start(backward)",
  },
}
