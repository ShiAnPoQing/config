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

  -- Ctrl-] goto tag
  -- Ctrl-[ goto pre tag
  ["<C-[>"] = { "<C-t>", "n", desc = "Jump to [count] older entry in the tag stack (default 1)" },
  ["<C-]>"] = { "<C-]>", "n", desc = "Jump to the definition of the keyword under the cursor" },
}
