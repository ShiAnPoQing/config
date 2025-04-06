return {
  -- Goto next in QuickFix List
  ["<leader>qn"] = {
    "<cmd>cnext<cr>zz",
    "n",
  },
  -- Goto prev in QuickFix List
  ["<leader>qp"] = {
    "<cmd>cprevious<cr>zz",
    "n",
  },
  -- Open QuickFix List
  ["<leader>qo"] = {
    "<cmd>copen<cr>zz",
    "n",
  },
  -- Toggle QuickFix List
  ["<leader>qq"] = {
    function()
      local qf_exists = false
      for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
          qf_exists = true
        end
      end
      if qf_exists == true then
        vim.cmd "cclose"
        return
      end
      if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
      end
    end,
    "n",
  },
}
