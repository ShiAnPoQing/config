require("neo-option").setlocal({
  concealcursor = {},
  formatoptions = { ["t"] = true, ["c"] = true, ["j"] = true, ["q"] = true },
})

local modifiable = vim.opt_local.modifiable
local buf = vim.api.nvim_get_current_buf()

if modifiable then
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
    buffer = buf,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.opt_local.conceallevel = 3
    end,
    buffer = buf,
  })
end
