vim.wo[0][0].concealcursor = ""

if vim.bo.modifiable then
  vim.bo.iskeyword = "@,48-57,_,192-255"
  local buf = vim.api.nvim_get_current_buf()
  -- conceallevel is local to window
  -- vim.wo[w][b] -> setlocal
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.wo[0][0].conceallevel = 0
    end,
    buffer = buf,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.wo[0][0].conceallevel = 3
    end,
    buffer = buf,
  })

  vim.bo.formatoptions = "tcqj"
  vim.bo.textwidth = 78
  vim.wo[0][0].colorcolumn = "79"
else
  -- neovim builtin help buffer is not modifiable

  -- list local to window
  -- setlocal
  -- 禁用 help buffer 在当前 window 中的显示
  -- 实际在后续所有 window 中该 buffer 都不显示 list，除非手动显式设置 local value
  vim.wo[0][0].list = false
end
