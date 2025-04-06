return {
  -- goto last cursor position
  ["<space>["] = { "<C-o>", "n" },
  -- goto new cursor position
  ["<space>]"] = { "<C-i>", "n", { noremap = true } },

  -- Ctrl-] goto tag
  -- Ctrl-[ goto pre tag
  ["<C-[>"] = { "<C-t>", "n", { noremap = true } }
}
