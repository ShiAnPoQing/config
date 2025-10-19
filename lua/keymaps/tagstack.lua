return {
  ["<C-[>"] = {
    "<C-t>",
    "n",
    desc = "Jump to [count] older entry in the tag stack (default 1)",
  },
  ["<Esc>"] = {
    "<Esc>",
    "n",
    desc = "Stop <Esc> same as <C-[>",
  },
  ["<C-]>"] = {
    "<C-]>",
    "n",
    desc = "Jump to the definition of the keyword under the cursor",
  },
  -- ["<tab>"] = {
  --   "<C-i>",
  --   "c",
  --   replace_keycodes = true,
  -- },
}

--[[

:[count]ta[g][!] {name}
:[count]po[p][!]

--]]
