return {
  -- Open QuickFix List
  -- ["<leader>qo"] = {
  --   "<cmd>copen<cr>zz",
  --   "n",
  --   desc = "Open QuickFix List",
  -- },
  ["<leader>qo"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "cnewer" .. vim.v.count1)
    end,
    "n",
    desc = "Newer QuickFix List",
  },
  ["<leader>qi"] = {
    function()
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "colder" .. vim.v.count1)
    end,
    "n",
    desc = "Older QuickFix List",
  },
  ["<leader>qc"] = {
    "<cmd>cclose<cr>zz",
    "n",
    desc = "Close QuickFix List",
  },
  ["<leader>qq"] = {
    function()
      local function callback()
        require("builtin.quickfix").toggle()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Toggle QuickFix List",
  },
  ["[q"] = {
    function()
      local function callback()
        require("builtin.quickfix").goto_prev_error()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Display the [count] previous error in the list that includes a file name.",
  },
  ["]q"] = {
    function()
      local function callback()
        require("builtin.quickfix").goto_next_error()
        require("repeat").set_motion(callback)
      end
      callback()
    end,
    "n",
    desc = "Display the [count] next error in the list that includes a file name.",
  },
  -- "[Q"
  -- "]Q"
  -- ["[fq"] = {
  --   function()
  --     local count = vim.v.count1
  --     --- @diagnostic disable-next-line
  --     local ok = pcall(vim.cmd, count .. "cpfile")
  --     if not ok then
  --       vim.cmd("clast")
  --     end
  --   end,
  --   "n",
  --   desc = "Display the last error in the [count] previous file in the list that includes a file name.",
  -- },
  -- ["]fq"] = {
  --   function()
  --     local count = vim.v.count1
  --     --- @diagnostic disable-next-line
  --     local ok = pcall(vim.cmd, count .. "cnfile")
  --     if not ok then
  --       vim.cmd("cfirst")
  --     end
  --   end,
  --   "n",
  --   desc = "Display the first error in the [count] next file in the list that includes a file name.",
  -- },
}
