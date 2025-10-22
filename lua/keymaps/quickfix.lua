return {
  -- Open QuickFix List
  ["<leader>qo"] = {
    "<cmd>copen<cr>zz",
    "n",
    desc = "Open QuickFix List",
  },
  -- Toggle QuickFix List
  ["<leader>qq"] = {
    function()
      local is_open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
      if is_open then
        vim.cmd("cclose")
      else
        vim.cmd("copen")
      end
    end,
    "n",
    desc = "Toggle QuickFix List",
  },
  ["[q"] = {
    function()
      local current_idx = vim.fn.getqflist({ idx = 0 }).idx
      local count = vim.v.count1

      if current_idx > 1 then
        vim.cmd(count .. "cprevious")
      else
        vim.cmd("clast")
      end

      vim.cmd("normal! zz")
    end,
    "n",
    desc = "Display the [count] previous error in the list that includes a file name.",
  },
  ["]q"] = {
    function()
      local fq = vim.fn.getqflist({ idx = 0, size = 0 })
      local current_idx = fq.idx
      local total = fq.size
      local count = vim.v.count1

      if current_idx < total then
        vim.cmd(count .. "cnext")
      else
        vim.cmd("cfirst")
      end

      vim.cmd("normal! zz")
    end,
    "n",
    desc = "Display the [count] next error in the list that includes a file name.",
  },
  ["[fq"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "cpfile")
      if not ok then
        vim.cmd("clast")
      end
    end,
    "n",
    desc = "Display the last error in the [count] previous file in the list that includes a file name.",
  },
  ["]fq"] = {
    function()
      local count = vim.v.count1
      --- @diagnostic disable-next-line
      local ok = pcall(vim.cmd, count .. "cnfile")
      if not ok then
        vim.cmd("cfirst")
      end
    end,
    "n",
    desc = "Display the first error in the [count] next file in the list that includes a file name.",
  },
}
