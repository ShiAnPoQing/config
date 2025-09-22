return {
  -- goto last cursor position
  ["<space>["] = {
    "<C-o>",
    "n",
    desc = "Go to [count] Older cursor position in jump list (not a motion command)",
  },
  -- goto new cursor position
  ["<space>]"] = {
    "<C-i>",
    "n",
    desc = "Go to [count] newer cursor position in jump list(not a motion command)",
    noremap = true,
  },
}
