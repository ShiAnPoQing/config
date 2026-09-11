local M = {}

--- @param config? any
function M.setup(config) end

--- @param tag string
function M.tselect(tag)
  if type(tag) ~= "string" or tag == "" then
    return
  end
  local current_win = vim.api.nvim_get_current_win()
  local list = vim.fn.taglist(tag)
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}
  for _, d in ipairs(list) do
    lines[#lines + 1] = d.name
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ns_id = vim.api.nvim_create_namespace("neo-tagstack")
  for i, d in ipairs(list) do
    local parser = vim.treesitter.get_string_parser(lines[i], "lua")
    local tree = parser:parse()[1]

    local query = vim.treesitter.query.get("lua", "highlights")

    for id, node in query:iter_captures(tree:root(), lines[i]) do
      local name = query.captures[id]

      local sr, sc, er, ec = node:range()

      vim.api.nvim_buf_set_extmark(buf, ns_id, i - 1 + sr, sc, {
        end_row = i - 1 + er,
        end_col = ec,
        hl_group = "@" .. name .. "." .. "lua",
      })
    end

    vim.api.nvim_buf_set_extmark(buf, ns_id, i - 1, 0, {
      virt_text = { { d.filename, "Normal" } },
      virt_text_pos = "eol_right_align",
    })
  end
  vim.api.nvim_set_option_value("modifiable", false, {
    buf = buf,
  })
  vim.api.nvim_set_option_value("filetype", "neo-tagstack", {
    buf = buf,
  })
  local win = vim.api.nvim_open_win(buf, true, {
    win = -1,
    split = "below",
  })
  vim.api.nvim_set_option_value("winfixbuf", true, {
    win = win,
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "<cr>", "", {
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(win)
      local d = list[cursor[1]]
      vim.api.nvim_win_call(current_win, function()
        vim.cmd("e " .. d.filename .. " | " .. d.cmd)
      end)
    end,
  })
  local id = vim.api.nvim_create_autocmd("WinLeave", {
    callback = function(ev)
      if ev.buf ~= buf then
        current_win = vim.api.nvim_get_current_win()
      end
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    buf = buf,
    callback = function()
      vim.api.nvim_del_autocmd(id)
      vim.api.nvim_buf_delete(buf, { force = true })
    end,
    once = true,
  })
end

return M
