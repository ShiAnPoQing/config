local function get_win_info()
  return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_virt_col_relative_screen_left()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local offset = virt_col - leftcol - 1

  return offset
end

local function get_virt_col_relative_screen_right()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local width = wininfo.width - wininfo.textoff
  local offset = width - (virt_col - leftcol)

  return offset
end

local function scroll_forward_one_page()
  local count = vim.v.count1
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local height = wininfo.height - vim.opt.cmdheight:get()
  local botline = wininfo.botline
  local topline = wininfo.topline
  local cursor = vim.api.nvim_win_get_cursor(0)

  local relative = botline - cursor[1]
  if botline - topline < height then
    relative = height + topline - cursor[1]
  end

  local fixed
  if relative == 0 then
    fixed = ""
  else
    fixed = relative .. "k"
  end
  vim.api.nvim_feedkeys(count .. vim.api.nvim_replace_termcodes("<C-b>", true, false, true) .. fixed, "nx", false)
end

local function scroll_backward_one_page()
  local count = vim.v.count1
  local wininfo = get_win_info()
  local topline = wininfo.topline
  local cursor = vim.api.nvim_win_get_cursor(0)
  local relative = cursor[1] - topline

  local fixed
  if relative == 0 then
    fixed = ""
  else
    fixed = relative .. "j"
  end
  vim.api.nvim_feedkeys(count .. vim.api.nvim_replace_termcodes("<C-f>", true, false, true) .. fixed, "nx", false)
end

local function scroll_half_screen_right()
  local offset = get_virt_col_relative_screen_left()
  return "zLg0" .. offset .. "l"
end

local function scroll_half_screen_right_i_mode()
  vim.cmd.stopinsert()
  local offset = get_virt_col_relative_screen_left()
  vim.api.nvim_feedkeys("zLg0" .. offset .. "li", "n", false)
end

local function scroll_half_screen_left()
  local offset = get_virt_col_relative_screen_right()
  return "zHg$" .. offset .. "h"
end

local function scroll_half_screen_left_i_mode()
  vim.cmd.stopinsert()
  local offset = get_virt_col_relative_screen_right()
  vim.api.nvim_feedkeys("zHg$" .. offset .. "hi", "n", false)
end

return {
  ["<space><C-j>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("down")
    end,
    "n",
  },
  ["<space><C-k>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("up")
    end,
    "n",
  },
  ["<space><C-l>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("right")
    end,
    "n",
  },
  ["<space><C-h>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("left")
    end,
    "n",
  },
  ["<C-j>"] = {
    {
      function()
        require("builtin.scroll").scroll_down()
      end,
      "n",
    },
    { "<C-y>", "x" },
    { "<C-o><C-y>", "i" },
    desc = "Scroll window [count] lines upwards in the buffer",
  },
  ["<C-k>"] = {
    {
      function()
        require("builtin.scroll").scroll_up()
      end,
      "n",
    },
    { "<C-e>", "x" },
    { "<C-o><C-e>", "i" },
    desc = "Scroll window [count] lines downwards in the buffer.",
  },
  ["<C-h>"] = {
    {
      function()
        require("builtin.scroll").scroll_left()
      end,
      "n",
    },
    { "2zl", "x" },
    { "<C-o>2zl", "i" },
    desc = "Move the view on the text [count] characters to the right",
  },
  ["<C-l>"] = {
    {
      function()
        require("builtin.scroll").scroll_right()
      end,
      "n",
    },
    { "2zh", "x" },
    { "<C-o>2zh", "i" },
    desc = "Move the view on the text [count] characters to the left",
  },
  ["<C-S-j>"] = {
    {
      function()
        scroll_backward_one_page()
      end,
      "n",
    },
    {
      function()
        vim.cmd.stopinsert()
        scroll_backward_one_page()
        vim.cmd.startinsert()
      end,
      "i",
    },
    { "<C-f>", "x" },
    desc = "Scroll window [count] pages Forwards (downwards) in the buffer.",
  },
  ["<C-S-k>"] = {
    {
      function()
        scroll_forward_one_page()
      end,
      "n",
    },
    {
      function()
        vim.cmd.stopinsert()
        scroll_forward_one_page()
        vim.cmd.startinsert()
      end,
      "i",
    },
    { "<C-b>", "x" },
    desc = "Scroll window [count] pages Backwards (upwards) in the buffer.",
  },
  ["<C-S-l>"] = {
    {
      function()
        return scroll_half_screen_right()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        scroll_half_screen_right_i_mode()
      end,
      "i",
    },
    desc = "Move the view on the text half a screenwidth to the right",
  },
  ["<C-S-h>"] = {
    {
      function()
        return scroll_half_screen_left()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        scroll_half_screen_left_i_mode()
      end,
      "i",
    },
    desc = "Move the view on the text half a screenwidth to the left",
  },
  ["<C-Space><C-j>"] = {
    function()
      local wininfo = get_win_info()
      local botline = wininfo.botline
      local line = vim.fn.line(".")
      if botline == line then
        return "<C-b>zb"
      else
        return "zb"
      end
    end,
    "n",
    expr = true,
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column.)",
  },
  ["<C-Space><C-k>"] = {
    function()
      local wininfo = get_win_info()
      local topline = wininfo.topline
      local line = vim.fn.line(".")
      if topline == line then
        return "<C-f>zt"
      else
        return "zt"
      end
    end,
    "n",
    expr = true,
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column.)",
  },
  ["<C-Space><C-l>"] = {
    "aal",
    "n",
    remap = true,
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["<C-Space><C-h>"] = {
    "aah",
    "n",
    remap = true,
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["<C-Space><C-n>"] = {
    "zz",
    "n",
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column)",
  },
  ["<C-Space><C-m>"] = {
    "aam",
    "n",
    remap = true,
    desc = "col at center of window (default cursor col)(leave the cursor in the same row)",
  },
  ["<S-ScrollWheelDown>"] = {
    { "zs", "n" },
    { "<C-o>zs", "i" },
  },
  ["<S-ScrollWheelUp>"] = {
    { "ze", "n" },
    { "<C-o>ze", "i" },
  },
}
