local M = {}

vim.api.nvim_set_hl(0, "WinActionFloat", { bg = "#8A2BE2" })

M.collectWinInfo = {}
M.sign = false

local cursorCmd

local function actionExchangeBuf(currentWinId, winId)
  local buf = vim.api.nvim_win_get_buf(winId)
  local currentBuf = vim.api.nvim_win_get_buf(currentWinId)
  vim.api.nvim_win_set_buf(currentWinId, buf)
  vim.api.nvim_win_set_buf(winId, currentBuf)
  vim.api.nvim_set_current_win(winId)
end

local function delCursorCmd()
  vim.api.nvim_del_autocmd(cursorCmd)
end

local function createCursorCmd(bufnr)
  local augroup = vim.api.nvim_create_augroup("MyGroup", { clear = true })
  cursorCmd = vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      M.cancelAction(bufnr)
    end,
    group = augroup,
  })
end

local function initM()
  M.sign = true
  M.collectWinInfo = {}
end

local function collectData(mark, winId)
  table.insert(M.collectWinInfo, {
    mark = mark,
    winId = winId,
  })
end

local function actionJump(winId)
  vim.api.nvim_set_current_win(winId)
end

local function clearFloatWin()
  local wins = vim.api.nvim_list_wins()

  for _, winId in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(winId)
    if config.relative ~= "" then
      vim.api.nvim_win_close(winId, false)
    end
  end
end

local function delActionMap(bufnr)
  for _, collect in ipairs(M.collectWinInfo) do
    pcall(vim.api.nvim_buf_del_keymap, bufnr, "n", tostring(collect.mark))
  end
end

local function delEscMap(bufnr)
  pcall(vim.api.nvim_buf_del_keymap, bufnr, "n", "<Esc>")
end

local function setKeymapForExchange(bufnr, currentWinId)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<Esc>",
    "<cmd>lua require('custom.plugins.win-action').cancelAction(" .. bufnr .. ")<cr>",
    {}
  )

  for _, collect in ipairs(M.collectWinInfo) do
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      tostring(collect.mark),
      "<cmd>lua require('custom.plugins.win-action').exchange("
        .. bufnr
        .. ","
        .. currentWinId
        .. ","
        .. collect.winId
        .. ")<CR>",
      {}
    )
  end
end

local function setKeymapForJump(bufnr)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<Esc>",
    "<cmd>lua require('custom.plugins.win-action').cancelAction(" .. bufnr .. ")<cr>",
    {}
  )

  for _, collect in ipairs(M.collectWinInfo) do
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      tostring(collect.mark),
      "<cmd>lua require('custom.plugins.win-action').jump(" .. bufnr .. "," .. collect.winId .. ")<CR>",
      {}
    )
  end
end

local function repeat_str(str, n)
  local result = ""
  for i = 1, n do
    result = result .. str
  end
  return result
end

local function createFloatWin(win_id, mark, title)
  local win_width = vim.api.nvim_win_get_width(win_id)
  local win_height = vim.api.nvim_win_get_height(win_id)

  local float_bufnr = vim.api.nvim_create_buf(false, true)

  local message = title .. repeat_str(" ", (win_width - 1) / 2 - 2) .. mark
  vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, { message })

  local win_config = {
    relative = "win", -- 相对于指定的窗口
    win = win_id, -- 指定相对的窗口ID
    width = win_width, -- 浮动窗口的宽度
    height = 1, -- 浮动窗口的高度
    row = win_height - 1,
    col = 0,
    style = "minimal", -- 最小化样式
    noautocmd = true, -- 禁用自动命令
  }

  local float_win = vim.api.nvim_open_win(float_bufnr, false, win_config)
  vim.api.nvim_win_set_option(float_win, "winhl", "Normal:WinActionFloat")
  vim.api.nvim_buf_set_option(float_bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(float_bufnr, "readonly", true)
end

local function isNeoTreeBufnr(win_id)
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "neo-tree" then
    return true
  end
  return false
end

function M.window_focus()
  if M.sign == true then
    local currentBuf = vim.api.nvim_get_current_buf()
    M.cancelAction(currentBuf)
    return
  end

  initM()
  vim.cmd("wincmd =")

  for mark, win_id in ipairs(vim.api.nvim_list_wins()) do
    if not isNeoTreeBufnr(win_id) then
      collectData(mark, win_id)
      createFloatWin(win_id, mark, "跳转")
    end
  end
  local currentBuf = vim.api.nvim_get_current_buf()
  setKeymapForJump(currentBuf)
  createCursorCmd(currentBuf)
end

function M.window_exchange()
  if M.sign == true then
    local currentBuf = vim.api.nvim_get_current_buf()
    M.cancelAction(currentBuf)
    return
  end

  initM()

  for mark, win_id in ipairs(vim.api.nvim_list_wins()) do
    if not isNeoTreeBufnr(win_id) then
      collectData(mark, win_id)
      createFloatWin(win_id, mark, "交换")
    end
  end

  local currentWinId = vim.api.nvim_get_current_win()
  local currentBuf = vim.api.nvim_get_current_buf()
  setKeymapForExchange(currentBuf, currentWinId)
  createCursorCmd(currentBuf)
end

function M.cancelAction(bufnr)
  M.sign = false
  clearFloatWin()
  delCursorCmd()
  delEscMap(bufnr)
  delActionMap(bufnr)
end

function M.jump(bufnr, win_id)
  M.sign = false

  actionJump(win_id)

  clearFloatWin()
  delActionMap(bufnr)
  delEscMap(bufnr)
end

function M.exchange(bufnr, currentWinId, win_id)
  M.sign = false

  actionExchangeBuf(currentWinId, win_id)

  clearFloatWin()
  delActionMap(bufnr)
  delEscMap(bufnr)
end

function M.setup()
  vim.api.nvim_create_user_command("WindowFocus", function()
    M.window_focus()
  end, {})
  vim.api.nvim_create_user_command("WindowExchange", function()
    M.window_exchange()
  end, {})
end

return M
