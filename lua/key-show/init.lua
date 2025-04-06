local M = {}

-- 创建或获取一个命名空间 ID
local ns_id = vim.api.nvim_create_namespace("key_logger")

function M.keyShow(Args)
  -- 定义一个回调函数，每次按键时调用
  local function key_logger(key)
    -- 打印按键日志
    print("Key pressed: " .. key)
  end

  -- 将回调函数添加为按键监听器
  vim.on_key(key_logger, ns_id)
end

function M.keyHide()
  vim.on_key(nil, ns_id)
end

return M
