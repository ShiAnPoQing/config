return {
  ["<C-[>"] = {
    "<C-t>",
    "n",
    desc = "Jump to [count] older entry in the tag stack (default 1)",
  },
  ["<C-]>"] = {
    "<cmd>tag<cr>",
    "n",
    desc = "Jump to [count] older entry in tag stack (default 1)",
  },
  -- ["<space>]"] = {
  --   function()
  --     return "<C-]>"
  --     -- local cwin = vim.api.nvim_get_current_win()
  --     -- local tagstack = vim.fn.gettagstack(cwin)
  --     -- local has
  --     -- for _, value in ipairs(tagstack.items) do
  --     --   if value.tagname == vim.fn.expand("<cword>") then
  --     --     has = true
  --     --     break
  --     --   end
  --     -- end
  --     -- if not has then
  --     --   return "<C-]>"
  --     -- end
  --   end,
  --   { "n", "x" },
  --   expr = true,
  --   desc = "Jump to the definition of the keyword under the cursor",
  -- },
}

--[[

:[count]ta[g][!] {name}
:[count]po[p][!]

--]]
