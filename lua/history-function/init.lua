local M = {}

local historyFunc = {
  callback = function()
    print("test")
  end,
  show = "test"
}

local default = {
  maxHistory = 10
}

function M.setup(config)
  vim.tbl_deep_extend("force", default, config or {})
  vim.api.nvim_create_user_command("ShowCustomTool", 'lua require("float-win").test()', { bang = true })
end

function M.openHistory()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hell World!" })
  vim.cmd("split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<cr>", { silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<cr>", { silent = true })
end

return M
