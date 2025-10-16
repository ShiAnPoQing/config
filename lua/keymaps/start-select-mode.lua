return {
  ["<M-`><M-h>"] = {
    "<Esc>gh",
    "i",
    desc = "Start Select Mode(Select h)",
  },
  ["<M-`><M-l>"] = {
    "<C-o>gh",
    "i",
    desc = "Start Select Mode(Select l)",
  },
  ["<M-`><M-j>"] = {
    "<C-o>vj<C-g>",
    "i",
    desc = "Start Select Mode(Select j)",
  },
  ["<M-`><M-k>"] = {
    "<C-o>vk<C-g>",
    "i",
    desc = "Start Select Mode(Select k)",
  },
  -- enter block select mode
  ["<M-`><M-`><M-h>"] = {
    "<Esc><C-v><C-G>",
    "i",
    desc = "Start Select Block Mode(Select h)",
  },
  ["<M-`><M-`><M-l>"] = {
    "<C-o><C-v><C-G>",
    "i",
    desc = "Start Select Block Mode(Select l)",
  },
  ["<M-`><M-`><M-j>"] = {
    "<C-o><C-v>j<C-G>",
    "i",
    desc = "Start Select Block Mode(Select j)",
  },
  ["<M-`><M-`><M-k>"] = {
    "<Esc><C-v>k<C-G>",
    "i",
    desc = "Start Select Block Mode(Select k)",
  },
  -- insert mode into select mode: right word
  ["<M-`><M-o>"] = {
    "<C-o>ve<C-G>",
    "i",
    desc = "Start Select Mode(Select o)",
  },
  -- insert mode into select mode: left word
  ["<M-`><M-i>"] = {
    "<Esc>gh<S-left>",
    "i",
    desc = "Start Select Mode(Select i)",
  },
}
