local M = {}

function M.test()
  print("key")
end

function M.setup(opt)
  print(opt)
  vim.opt.number = false
end

return M
