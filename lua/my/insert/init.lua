--- @class my.insert
--- @field float my.insert
local M = vim._defer_require("my.insert", {})

local VISUAL_LINE = "V"
local VISUAL_BLOCK = ""
local VISUAL = "v"

function M.cursor_before() end

function M.cursor_after() end

function M.visual_first()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    vim.api.nvim_win_set_cursor(0, { start_row, start_col })
    vim.api.nvim_feedkeys(count .. "i", "nt", false)
    return
  end

  if mode == VISUAL_LINE then
    my.insert.visual_line_first()
    return
  end

  if mode == VISUAL_BLOCK then
    my.insert.visual_block_first()
    return
  end
end

function M.visual_last()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.api.nvim_win_set_cursor(0, { row, col })
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    return
  end

  if mode == VISUAL_LINE then
    my.insert.visual_line_last()
    return
  end

  if mode == VISUAL_BLOCK then
    my.insert.visual_block_last()
    return
  end
end

--- visual mode
--- visual-line mode
--- visual-block mode
function M.visual_first_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    vim.api.nvim_win_set_cursor(0, { start_row, start_col })
    vim.api.nvim_feedkeys(count .. "i", "nt", false)
    return
  end

  if mode == VISUAL_LINE then
    my.insert.visual_line_first_non_blank()
    return
  end

  if mode == VISUAL_BLOCK then
    my.insert.visual_block_first()
    return
  end
end

function M.visual_last_non_blank()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1

  if mode == VISUAL then
    vim.cmd("normal! " .. VISUAL)
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.api.nvim_win_set_cursor(0, { row, col })
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    return
  end

  if mode == VISUAL_LINE then
    my.insert.visual_line_last_non_blank()
    return
  end

  if mode == VISUAL_BLOCK then
    my.insert.visual_block_last()
    return
  end
end

function M.visual_line_first()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, 0 })
      else
        vim.api.nvim_mcursor(0, { i, 0 })
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "i", "nt", false)
  local atom_total = 2
  local atom_count = 0
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function()
      atom_count = atom_count + 1
      if atom_count == atom_total then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
    end,
  })
end

function M.visual_line_last()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, #line })
      else
        vim.api.nvim_mcursor(0, { i, #line })
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "a", "nt", false)
  local atom_total = 2
  local atom_count = 0
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function()
      atom_count = atom_count + 1
      if atom_count == atom_total then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
    end,
  })
end

function M.visual_line_first_non_blank()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      local col = line:find("%S") or 1
      col = col - 1
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, col })
      else
        vim.api.nvim_mcursor(0, { i, col })
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "i", "nt", false)
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
    end,
  })
end

function M.visual_line_last_non_blank()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_LINE)
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
    for i = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, i - 1, i, true)[1]
      local col = line:reverse():find("%S") or 0
      col = #line - col + 1
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, col })
      else
        vim.api.nvim_mcursor(0, { i, col })
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "a", "nt", false)
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
    end,
  })
end

function M.visual_block_first()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_BLOCK)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, start_col })
      else
        vim.api.nvim_mcursor(0, { i, start_col })
      end
    end
  end

  vim.api.nvim_feedkeys(count .. "i", "nt", false)
  vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      if ev.data.type == "insert" then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
    end,
  })
end

function M.visual_block_last()
  local count = vim.v.count1
  local mc = vim.api.nvim_create_namespace("nvim.multicursor")
  local extmarks = vim.api.nvim_buf_get_extmarks(0, mc, 0, -1, { limit = 1 })
  if #extmarks == 0 then
    vim.cmd("normal! " .. VISUAL_BLOCK)
    local start_row = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    for i = start_row, end_row do
      if i == end_row then
        vim.api.nvim_win_set_cursor(0, { i, end_col })
      else
        vim.api.nvim_mcursor(0, { i, end_col })
      end
    end
    vim.api.nvim_feedkeys(count .. "a", "nt", false)
    vim.api.nvim_create_autocmd("CmdAtom", {
      callback = function(ev)
      if ev.data.type == "insert" then
        vim.api.nvim_buf_clear_namespace(0, mc, 0, -1)
        return true
      end
      end,
    })
  end
end

function M.visual_line_screen_first() end

return M
