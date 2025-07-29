return {
  ["<M-`><M-h>"] = {
    "<Esc>gh",
    "i",
  },
  ["<M-`><M-l>"] = {
    "<C-o>gh",
    "i",
  },
  ["<M-`><M-j>"] = {
    "<C-o>vj<C-g>",
    "i",
  },
  ["<M-`><M-k>"] = {
    "<C-o>vk<C-g>",
    "i",
  },
  -- enter block select mode
  ["<M-`><M-`><M-h>"] = {
    "<Esc><C-v><C-G>",
    "i",
  },
  ["<M-`><M-`><M-l>"] = {
    "<C-o><C-v><C-G>",
    "i",
  },
  ["<M-`><M-`><M-j>"] = {
    "<C-o><C-v>j<C-G>",
    "i",
  },
  ["<M-`><M-`><M-k>"] = {
    "<Esc><C-v>k<C-G>",
    "i",
  },
  -- insert mode into select mode: right word
  ["<M-`><M-o>"] = {
    "<C-o>ve<C-G>",
    "i",
  },
  -- insert mode into select mode: left word
  ["<M-`><M-i>"] = {
    "<Esc>gh<S-left>",
    "i",
  },
}
