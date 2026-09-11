local M = {}

local function get_buf_name()
  local source = debug.getinfo(1, "S").source:sub(2)
  local path = vim.fs.dirname(vim.fs.dirname(source))
  path = path .. "/[CodeBox].lua"
  return path
end

function M.open()
  local buf = vim.api.nvim_create_buf(false, false)
  local win = vim.api.nvim_open_win(buf, true, {
    win = 0,
    split = "right",
  })
  vim.api.nvim_buf_set_name(buf, get_buf_name())
  vim.api.nvim_buf_call(buf, function()
    vim.bo.filetype = "lua"
    vim.bo.buftype = "acwrite"
  end)
  local lines = {
    "------",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local ns_id = vim.api.nvim_create_namespace("codebox")
  -- vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
  --   end_row = 0,
  --   end_col = 0,
  --   invalidate = false,
  --   virt_lines = {
  --     {
  --       {
  --         "Write Lua Code Here",
  --       },
  --     },
  --     {
  --       {
  --         "",
  --       },
  --     },
  --   },
  --   virt_lines_leftcol = true,
  --   right_gravity = false,
  --   virt_lines_above = true,
  -- })
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
    end_col = 3,
    virt_text = { { "Scope:" } },
    virt_text_pos = "overlay",
    right_gravity = false,
  })
  local locked_lines = {
    [0] = "------",
  }
  local locked
  vim.api.nvim_buf_attach(buf, false, {
    on_bytes = function(
      _,
      _,
      _,
      start_row,
      start_col,
      start_byte,
      old_end_row,
      old_end_col,
      old_end_byte,
      new_end_row,
      new_end_col,
      new_end_byte
    )
      if start_row == 0 and old_end_row > 0 then
        local removed = old_end_row - start_row
        if removed > 0 then
          if not locked then
            locked = true
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(buf, 0, 0, false, { locked_lines[0] })
              locked = false
            end)
          end
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buf = buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      vim.print(lines)
      vim.bo[buf].modified = false
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    buf = buf,
    callback = function()
      vim.api.nvim_buf_call(buf, function()
        vim.bo.modified = false
      end)
    end,
  })
  vim.api.nvim_create_autocmd("WinLeave", {
    buf = buf,
    callback = function()
      vim.api.nvim_buf_call(buf, function()
        vim.bo.modified = false
      end)
    end,
  })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-b>", true, false, true), "n", false)
end

return M
