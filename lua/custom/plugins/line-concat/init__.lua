local M = {}

function M.LineConnect(count, mode, textobj)
  local begin_col = vim.api.nvim_win_get_cursor(0)[2]

  if vim.opt.operatorfunc ~= "v:lua.my_lineconnect" then
    _G.my_lineconnect = function(type)
      local begin_line_number
      local end_line_number

      if mode == "v" then
        vim.cmd([[
        exe "norm! " .. "\<ESC>"
        ]])
      end

      if type == "line" then
        begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
        end_line_number = vim.api.nvim_buf_get_mark(0, "]")
      elseif type == "char" then
        begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
        end_line_number = vim.api.nvim_buf_get_mark(0, "]")
      elseif type == "block" then
        begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
        end_line_number = vim.api.nvim_buf_get_mark(0, "]")
      end

      local i = 0
      local max = 0

      while true do
        max = max + 1

        if max > 300 then
          break
        end

        i = i + 1

        vim.cmd([[
        exec 'norm! j0i' .. "\<BS>"
        ]])

        local times = end_line_number[1] - begin_line_number[1]

        if times == 0 then
          if i == end_line_number[1] - begin_line_number[1] + 1 then
            vim.api.nvim_win_set_cursor(0, { begin_line_number[1], begin_col })
            break
          end
        else
          if i == end_line_number[1] - begin_line_number[1] then
            vim.api.nvim_win_set_cursor(0, { begin_line_number[1], begin_col })
            break
          end
        end
      end
    end

    vim.opt.operatorfunc = "v:lua.my_lineconnect"
    vim.api.nvim_feedkeys("g@", "n", false)
  else
    vim.api.nvim_feedkeys("g@", "n", false)
  end
end

return M
