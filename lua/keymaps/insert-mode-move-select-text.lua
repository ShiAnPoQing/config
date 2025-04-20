local function set_mark(start_pos, end_pos)
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
  vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
end

local get_new_line = {
  ["left"] = function(select, line_to_start, line_to_end)
    local line_to_start_end_char = vim.fn.strcharpart(line_to_start, vim.fn.strchars(line_to_start) - 1, 1)
    local line_to_start_without_end_char = line_to_start:sub(1,
      vim.str_byteindex(line_to_start, vim.fn.strchars(line_to_start) - 1))

    local line = line_to_start_without_end_char .. select .. line_to_start_end_char .. line_to_end
    local mark_offset = - #line_to_start_end_char

    return line, mark_offset
  end,
  ["right"] = function(select, line_to_start, line_to_end)
    local line_to_end_start_char = line_to_end:sub(1, vim.str_byteindex(line_to_end, 1))
    local line_to_end_without_start_char = line_to_end:sub(vim.str_byteindex(line_to_end, 1) + 1)

    local line = line_to_start .. line_to_end_start_char .. select .. line_to_end_without_start_char
    local mark_offset = vim.str_byteindex(line_to_end, 1)

    return line, mark_offset
  end
}

local Action = {
  ["left"] = {
    is_boundary = function(line_to_start, line_to_end)
      return line_to_start == ""
    end
  },
  ["right"] = {
    is_boundary = function(line_to_start, line_to_end)
      return line_to_end == ""
    end
  }
}

--- @param action "left"|"right"
local function move_select_text(action)
  vim.api.nvim_exec2([[  execute "normal! \<Esc>gvy"  ]], {})

  local select = vim.fn.getreg('"')
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local _, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(start_col + #select + 1)

  if Action[action].is_boundary(line_to_start, line_to_end) then
    vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
    return
  end

  local new_line, mark_offset = get_new_line[action](select, line_to_start, line_to_end)
  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })
  set_mark({ start_row, start_col + mark_offset }, { start_row, end_col + mark_offset })

  vim.api.nvim_exec2([[  execute "normal! gv\<C-g>"  ]], {})
end













return {
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
    "<S-right>",
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
    "<C-o>",
    "i"
  },
  -- insert mode into select mode: left word
  ["<M-`><M-i>"] = {
    "<Esc>gh<S-left>",
    "i"
  },
}
