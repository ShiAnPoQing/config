local M = {}

function M.feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "nx", false)
end

function M.insert_mode(callback)
  return function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local winview = vim.fn.winsaveview()
    vim.api.nvim_create_autocmd("InsertLeave", {
      once = true,
      callback = function()
        vim.fn.winrestview({ curswant = winview.curswant })
        callback()
        vim.api.nvim_create_autocmd("CursorMovedI", {
          once = true,
          callback = function()
            vim.fn.winrestview({ curswant = winview.curswant })
          end,
        })
        local start_insert = "i<right>"
        if cursor[2] == 0 then
          start_insert = "a<left>"
        end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(start_insert, true, false, true), "in", false)
      end,
    })
    vim.cmd.stopinsert()
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
