return {
  ["[t"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, vim.v.count1 .. "tprevious")
      if vim.v.count1 == 1 then
        if not ok then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "tlast")
        end
      else
        if not ok then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "trewind")
        end
      end
    end,
    "n",
    desc = ":tprevious",
  },
  ["]t"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, vim.v.count1 .. "tnext")
      if vim.v.count1 == 1 then
        if not ok then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "trewind")
        end
      else
        if not ok then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "tlast")
        end
      end
    end,
    "n",
    desc = ":tnext",
  },
  -- 如果当前不在 tagstack 栈顶或栈底
  -- :0tag<cr> 和 :0pop<cr> 跳转到当前 tag 位置
  ["{t"] = {
    {
      function()
        return "<cmd>" .. vim.v.count1 .. "pop | tags<cr>"
      end,
      "n",
      expr = true,
      desc = "Jump to [count] older entry in the tag stack (default 1)",
    },
  },
  ["}t"] = {
    {
      function()
        return "<cmd>" .. vim.v.count1 .. "tag | tags<cr>"
      end,
      "n",
      expr = true,
      desc = "Jump to [count] older entry in tag stack (default 1)",
    },
    { "<nop>", "x" },
  },
  -- ["<space>]"] = {
  --   function()
  --     -- return "<C-]>"
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
  --
  --     local name = vim.fn.expand("<cword>") -- 默认使用光标下单词
  --
  --     -- 获取所有匹配 tag
  --     local tags = vim.fn.taglist(name)
  --     if #tags == 0 then
  --       print("No tags found for: " .. name)
  --       return
  --     end
  --
  --     -- 转成 location list entry
  --     local loclist = {}
  --     for _, t in ipairs(tags) do
  --       table.insert(loclist, {
  --         filename = t.filename,
  --         lnum = t.cmd:gsub(".*\\v(%d+).*", "%1"), -- 从 cmd 提取行号
  --         col = 1,
  --         text = t.name,
  --       })
  --     end
  --
  --     -- 把 location list 写入当前窗口
  --     vim.fn.setloclist(0, {}, " ", { title = "Tag matches: " .. name, items = loclist })
  --
  --     -- 打开 location list
  --     vim.cmd("lopen")
  --   end,
  --   { "n", "x" },
  --   -- expr = true,
  --   desc = "Jump to the definition of the keyword under the cursor",
  -- },
}

--[[

:[count]ta[g][!] {name}
:[count]po[p][!]

--]]
