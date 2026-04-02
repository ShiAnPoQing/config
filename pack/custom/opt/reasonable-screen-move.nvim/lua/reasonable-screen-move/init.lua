local M = {}
local ns_id = vim.api.nvim_create_namespace("reasonable-scroll-namespace")

local function get_scrolloff()
  ---@diagnostic disable-next-line: undefined-field
  return vim.opt_local.scrolloff:get()
end

local function set_extmark(extmarks)
  for _, extmark in ipairs(extmarks) do
    pcall(vim.api.nvim_buf_set_extmark, 0, ns_id, extmark.line, 0, {
      virt_text = { { extmark.text, "EyeLabel" } },
      virt_text_win_col = extmark.virt_text_win_col,
      hl_mode = "combine",
    })
    pcall(vim.api.nvim_buf_set_extmark, 0, ns_id, extmark.line, 0, {
      hl_group = "EyeLayer",
      end_row = extmark.line + 1,
      hl_eol = true,
    })
  end
end

function M.top()
  local count = vim.v.count
  local line = vim.fn.line(".")
  local topline = vim.fn.line("w0") + get_scrolloff()
  if count == 0 and line == topline then
    require("reasonable-scroll").scroll_page_up(1)
  else
    vim.api.nvim_feedkeys(count + 1 .. "H", "nx", false)
  end
end

function M.bottom()
  local count = vim.v.count
  local line = vim.fn.line(".")
  local botline = vim.fn.line("w$") - get_scrolloff()
  if count == 0 and line == botline then
    require("reasonable-scroll").scroll_page_down(1)
  else
    vim.api.nvim_feedkeys(count + 1 .. "L", "nx", false)
  end
end

function M.first_non_blank_character()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys("g^", "nx", false)
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor2[2] then
    vim.api.nvim_feedkeys("g0", "nx", false)
  end
end

function M.last_non_blank_character()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g<end>", true, false, true), "nx", false)
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor2[2] then
    vim.api.nvim_feedkeys("g$", "nx", false)
  end
end

function M.first_character()
  local count = vim.v.count
  local key = "g0"
  if count == 0 then
    vim.api.nvim_feedkeys(key, "nx", false)
    return
  end
  local line = vim.fn.line(".")
  local k_extmark = {
    text = "k",
    line = line - count - 1,
  }
  local j_extmark = {
    text = "j",
    line = line + count - 1,
  }
  local l_extmark = {
    text = "l",
    line = line - 1,
  }
  local extmarks = { k_extmark, j_extmark, l_extmark }
  ---@diagnostic disable-next-line: undefined-field
  if vim.list_contains(vim.opt_local.virtualedit:get(), "all") then
    k_extmark.virt_text_win_col = 0
    j_extmark.virt_text_win_col = 0
    l_extmark.virt_text_win_col = count
  else
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    local up_line = vim.api.nvim_buf_get_lines(0, line - 1 - count, line - count, false)[1]
    local down_line = vim.api.nvim_buf_get_lines(0, line - 1 + count, line + count, false)[1]
    l_extmark.virt_text_win_col = count
    if wininfo.leftcol <= vim.fn.strdisplaywidth(up_line) then
      k_extmark.virt_text_win_col = 0
    else
      k_extmark.virt_text_win_col = -2
      k_extmark.text = "←k"
    end
    if wininfo.leftcol <= vim.fn.strdisplaywidth(down_line) then
      j_extmark.virt_text_win_col = 0
    else
      j_extmark.virt_text_win_col = -2
      j_extmark.text = "←j"
    end
  end
  set_extmark(extmarks)
  vim.cmd.redraw()
  local char = vim.fn.getcharstr()
  if char == "j" or char == "k" then
    key = count .. char .. key
  elseif char == "l" then
    key = key .. count .. char
  end
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  vim.api.nvim_feedkeys(key, "nx", false)
end

function M.last_character()
  local count = vim.v.count
  local key = "g$"
  if count == 0 then
    vim.api.nvim_feedkeys(key, "nx", false)
    return
  end

  local line = vim.fn.line(".")
  local k_extmark = {
    text = "k",
    line = line - count - 1,
  }
  local j_extmark = {
    text = "j",
    line = line + count - 1,
  }
  local h_extmark = {
    text = "h",
    line = line - 1,
  }
  local extmarks = { k_extmark, j_extmark, h_extmark }
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local width = wininfo.width - wininfo.textoff
  ---@diagnostic disable-next-line: undefined-field
  if vim.list_contains(vim.opt_local.virtualedit:get(), "all") then
    k_extmark.virt_text_win_col = width - 1
    j_extmark.virt_text_win_col = width - 1
    h_extmark.virt_text_win_col = width - count - 1
  else
    local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    local up_line = vim.api.nvim_buf_get_lines(0, line - 1 - count, line - count, false)[1]
    local down_line = vim.api.nvim_buf_get_lines(0, line - 1 + count, line + count, false)[1]
    local current_line_display_width = vim.fn.strdisplaywidth(current_line)
    local up_line_display_width = vim.fn.strdisplaywidth(up_line)
    local down_line_display_width = vim.fn.strdisplaywidth(down_line)
    if current_line_display_width < width + wininfo.leftcol then
      h_extmark.virt_text_win_col = current_line_display_width - wininfo.leftcol - count - 1
    else
      h_extmark.virt_text_win_col = width - count - 1
    end
    if up_line_display_width < width + wininfo.leftcol then
      k_extmark.virt_text_win_col = up_line_display_width - wininfo.leftcol - 1
    else
      k_extmark.virt_text_win_col = width - 1
    end
    if down_line_display_width < width + wininfo.leftcol then
      j_extmark.virt_text_win_col = down_line_display_width - wininfo.leftcol - 1
    else
      j_extmark.virt_text_win_col = width - 1
    end
  end
  set_extmark(extmarks)
  vim.cmd.redraw()
  local char = vim.fn.getcharstr()
  if char == "j" or char == "k" then
    key = count .. char .. key
  elseif char == "h" then
    key = key .. count .. char
  end
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  vim.api.nvim_feedkeys(key, "nx", false)
end

return M
