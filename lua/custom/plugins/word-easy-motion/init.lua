local M = {}

local function test()
  local ns_id = vim.api.nvim_create_namespace("Test")
  vim.on_key(function(key, typed)
    print(key, typed)
  end, ns_id, {})
end

function M.setup()
  vim.api.nvim_create_user_command("EasyMotionWord", function()
    test()
  end, {})
end

return M
