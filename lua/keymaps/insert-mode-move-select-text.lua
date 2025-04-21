local function set_mark(start_pos, end_pos)
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
  vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
end

local MoveAction = {
  ["left"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      return line_to_start == ""
    end,
    get_new_line = function(select, line_to_start, line_to_end)
      local line_to_start_end_char = vim.fn.strcharpart(line_to_start, vim.fn.strchars(line_to_start) - 1, 1)
      local line_to_start_without_end_char = line_to_start:sub(1,
        vim.str_byteindex(line_to_start, vim.fn.strchars(line_to_start) - 1))

      local line = line_to_start_without_end_char .. select .. line_to_start_end_char .. line_to_end
      local mark_offset = - #line_to_start_end_char

      return line, mark_offset
    end
  },
  ["right"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      return line_to_end == ""
    end,
    get_new_line = function(select, line_to_start, line_to_end)
      local line_to_end_start_char = line_to_end:sub(1, vim.str_byteindex(line_to_end, 1))
      local line_to_end_without_start_char = line_to_end:sub(vim.str_byteindex(line_to_end, 1) + 1)

      local line = line_to_start .. line_to_end_start_char .. select .. line_to_end_without_start_char
      local mark_offset = vim.str_byteindex(line_to_end, 1)

      return line, mark_offset
    end
  }
}

--- @param action "left"|"right"
local function move_select_text(action)
  vim.api.nvim_exec2([[  execute "normal! \<Esc>gvy"  ]], {})
  local Action = MoveAction[action]

  local select = vim.fn.getreg('"')
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local _, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(start_col + #select + 1)

  if Action.is_outer_boundary(line_to_start, line_to_end) then
    vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
    return
  end

  local new_line, mark_offset = Action.get_new_line(select, line_to_start, line_to_end)
  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  set_mark({ start_row, start_col + mark_offset }, { start_row, end_col + mark_offset })

  vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
end


local WordMoveAction = {
  ["left"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      if line_to_start:match("^%s*$") then
        vim.api.nvim_exec2([[
        execute "normal! Pgv\<C-G>"
        ]], {})
        return true
      end
      return false
    end,
    get_new_line = function(line_to_start, line_to_end, select)
      local mark_offset
      local new_line_to_start = line_to_start:gsub("(%S+)(%s*)$", function(match, space)
        mark_offset = - #space - #match
        return select .. space .. match
      end)
      local line = new_line_to_start .. line_to_end
      return line, mark_offset
    end
  },
  ["right"] = {
    is_outer_boundary = function(line_to_start, line_to_end)
      if line_to_end:match("^%s*$") then
        vim.api.nvim_exec2([[
        execute "normal! Pgv\<C-G>"
        ]], {})
        return true
      end
      return false
    end,
    get_new_line = function(line_to_start, line_to_end, select)
      local mark_offset
      local new_line_to_end = line_to_end:gsub("^(%s*)(%S+)", function(space, match)
        mark_offset = #space + #match
        return match .. space .. select
      end)
      local line = line_to_start .. new_line_to_end
      return line, mark_offset
    end
  }
}

--- @param action "left"| "right"
local function word_move_select_text(action)
  local Action = WordMoveAction[action]

  vim.api.nvim_exec2([[
  execute "normal! \<C-G>d"
  ]], {})

  local select = vim.fn.getreg('"')
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(start_col + 1)

  if Action.is_outer_boundary(line_to_start, line_to_end) then
    return
  end

  local new_line, mark_offset = Action.get_new_line(line_to_start, line_to_end, select)

  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  vim.api.nvim_buf_set_mark(0, "<", start_row, start_col + mark_offset, {})
  vim.api.nvim_buf_set_mark(0, ">", start_row, start_col + mark_offset + #select - 1, {})

  vim.api.nvim_exec2([[
  execute "normal! gv\<C-G>"
  ]], {})
end

--- @param action "left" | "right"
local function start_end_move_select_text(action)
  vim.api.nvim_exec2([[
  execute "normal! \<C-G>d"
  ]], {})

  if action == "left" then
    vim.api.nvim_exec2([[
    execute "normal! ^P"
    ]], {})
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.fn.getreg('"')

    vim.api.nvim_buf_set_mark(0, "<", row, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", row, #text - 1, {})
    vim.api.nvim_exec2([[
    execute "normal! gv\<C-G>"
    ]], {})
  else
    vim.api.nvim_exec2([[
    execute "normal! g_"
    ]], {})

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.fn.getreg('"')

    vim.api.nvim_buf_set_mark(0, "<", row, col + 1, {})
    vim.api.nvim_buf_set_mark(0, ">", row, col + #text, {})
    vim.api.nvim_exec2([[
    execute "normal! pgv\<C-G>"
    ]], {})
  end
end


return {
  ["<C-space><C-l>"] = {
    function()
      start_end_move_select_text('right')
    end,
    "s"
  },
  ["<C-space><C-h>"] = {
    function()
      start_end_move_select_text('left')
    end,
    "s",
  },
  ["<C-o>"] = {
    function()
      word_move_select_text("right")
    end,
    "s"
  },
  ["<C-i>"] = {
    function()
      word_move_select_text("left")
    end,
    "s"
  },
  ["<C-h>"] = {
    function()
      move_select_text("left")
    end,
    "s"
  },
  ["<C-l>"] = {
    function()
      move_select_text("right")
    end,
    "s"
  },
  ["<M-o>"] = {
    "<C-G>e<C-G>",
    "s"
  },
  ["<M-i>"] = {
    "<S-left>",
    "s"
  },
  -- insert mode into select mode: left
  ["<M-`><M-h>"] = {
    "<Esc>gh",
    "i"
  },
  -- insert mode into select mode: right
  ["<M-`><M-l>"] = {
    "<C-o>gh",
    "i"
  },
  -- insert mode into select mode: right word
  ["<M-`><M-o>"] = {
    "<C-o>ve<C-G>",
    "i"
  },
  -- insert mode into select mode: left word
  ["<M-`><M-i>"] = {
    "<Esc>gh<S-left>",
    "i"
  },
}
