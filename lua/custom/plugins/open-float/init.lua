local M = {}

local border = {
  -- 左上角
  "╭",
  -- 上边框
  "─",
  -- 右上角
  "╮",
  -- 右边框
  "│",
  -- 右下角
  "╯",
  -- 下边框
  "─",
  -- 左下角
  "╰",
  -- 左边框
  "│",
}

function M.opent_float()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.6)
  local win_width = math.ceil(width * 0.6)

  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = border,
  }
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- local file = io.open(vim.fn.stdpath("config") .. "/lua/nvim-extmark-doc/nvim_set_extmark.txt", "r")
  local lines = {}

  -- for line in file:lines() do
  -- 	table.insert(lines, line)
  -- end
  --
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, lines)
  -- vim.api.nvim_buf_set_option(buf, "number", true)
  -- vim.api.nvim_win_set_option(win, "winhighlight", "Visual:search")
  --  vim.api.nvim_set_option_value("")

  vim.keymap.set("n", "<C-j>", function()
    require("utils.float.win-move").float_win_move("j", 1)
  end, { buffer = buf })
  vim.keymap.set("n", "<C-k>", function()
    require("utils.float.win-move").float_win_move("k", 1)
  end, { buffer = buf })
  vim.keymap.set("n", "<C-h>", function()
    require("utils.float.win-move").float_win_move("h", 1)
  end, { buffer = buf })
  vim.keymap.set("n", "<C-l>", function()
    require("utils.float.win-move").float_win_move("l", 1)
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>l", function()
    require("utils.float.win-move").float_win_boundary_move("l")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>h", function()
    require("utils.float.win-move").float_win_boundary_move("h")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>k", function()
    require("utils.float.win-move").float_win_boundary_move("k")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>j", function()
    require("utils.float.win-move").float_win_boundary_move("j")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>m", function()
    require("utils.float.win-move").float_win_boundary_move("m")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>n", function()
    require("utils.float.win-move").float_win_boundary_move("n")
  end, { buffer = buf })
  vim.keymap.set("n", "<C-space>c", function()
    require("utils.float.win-move").float_win_boundary_move("c")
  end, { buffer = buf })
end

return M
