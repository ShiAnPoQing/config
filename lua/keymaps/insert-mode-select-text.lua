return {
  ["<M-o>"] = {
    "<C-G>e<C-G>",
    "s"
  },
  ["<M-i>"] = {
    "<S-left>",
    "s"
  },
  -- insert mode into select mode: left
  ["<M-`><M-h>"] = {
    "<Esc>gh",
    "i"
  },
  -- insert mode into select mode: right
  ["<M-`><M-l>"] = {
    "<C-o>gh",
    "i"
  },
  ["<M-`><M-`><M-l>"] = {
    "<C-o><C-v><C-G>",
    "i"
  },
  ["<M-`><M-`><M-h>"] = {
    "<Esc><C-v><C-G>",
    "i"
  },
  -- insert mode into select mode: right word
  ["<M-`><M-o>"] = {
    "<C-o>ve<C-G>",
    "i"
  },
  -- insert mode into select mode: left word
  ["<M-`><M-i>"] = {
    "<Esc>gh<S-left>",
    "i"
  },
}
