return {
  ["<C-[>"] = {
    "<C-t>",
    "n",
    desc = "Jump to [count] older entry in the tag stack (default 1)",
  },
  ["<C-]>"] = {
    "<C-]>",
    "n",
    desc = "Jump to the definition of the keyword under the cursor",
  },
}

--[[

:[count]ta[g][!] {name}
:[count]po[p][!]

--]]
