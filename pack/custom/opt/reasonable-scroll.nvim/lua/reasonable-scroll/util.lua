local M = {}

function M.feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "nx", false)
end

function M.insert_mode(callback)
  return function()
    vim.cmd.stopinsert()
    vim.schedule(function()
      callback()
      vim.api.nvim_feedkeys("a", "n", false)
    end)
  end
end

function M.get_wininfo(win)
  win = win or vim.api.nvim_get_current_win()
  return vim.fn.getwininfo(win)[1]
end

function M.get_scrolloff()
  return vim.api.nvim_get_option_value("scrolloff", {
    win = vim.api.nvim_get_current_win(),
  })
end

function M.get_sidescrolloff()
  return vim.api.nvim_get_option_value("sidescrolloff", {
    win = vim.api.nvim_get_current_win(),
  })
end

return M
