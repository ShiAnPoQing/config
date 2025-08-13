local M = {}

local function get_win_and_boundary_width()
  local width = vim.api.nvim_win_get_width(0) + 2
  local boundary_width = vim.opt.columns:get()

  return width, boundary_width
end

local function get_win_and_boundary_height()
  local boundary_height = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local height = vim.api.nvim_win_get_height(0) + 2
  return height, boundary_height
end

local function get_center_pos(outer, inner)
  return math.ceil((outer - inner) / 2)
end

function M.float_win_move(dir, step)
  local opts = vim.api.nvim_win_get_config(0)

  local row = opts.row
  local col = opts.col

  if dir == "j" then
    local height, boundary_height = get_win_and_boundary_height()
    if row + height > boundary_height then
      row = boundary_height - height
    else
      row = row + step
    end
  elseif dir == "k" then
    if row - step < 0 then
      row = 0
    else
      row = row - step
    end
  elseif dir == "h" then
    if col - step < 0 then
      col = 0
    else
      col = col - step
    end
  elseif dir == "l" then
    local width, boundary_width = get_win_and_boundary_width()
    if col + width > boundary_width then
      col = boundary_width - width
    else
      col = col + step
    end
  end
  vim.api.nvim_win_set_config(0, { row = row, col = col, relative = "editor" })
end

--- @param dir "h"|"j"|"k"|"l"|"n"|"m"|"c"
function M.float_win_boundary_move(dir)
  local opts = vim.api.nvim_win_get_config(0)
  local row = opts.row
  local col = opts.col

  if dir == "j" then
    local height, boundary_height = get_win_and_boundary_height()
    row = boundary_height - height
  elseif dir == "k" then
    row = 0
  elseif dir == "h" then
    col = 0
  elseif dir == "l" then
    local width, boundary_width = get_win_and_boundary_width()
    col = boundary_width - width
  elseif dir == "n" then
    local height, boundary_height = get_win_and_boundary_height()
    row = get_center_pos(boundary_height, height)
  elseif dir == "m" then
    local width, boundary_width = get_win_and_boundary_width()
    col = get_center_pos(boundary_width, width)
  elseif dir == "c" then
    local height, boundary_height = get_win_and_boundary_height()
    local width, boundary_width = get_win_and_boundary_width()
    col = get_center_pos(boundary_width, width)
    row = get_center_pos(boundary_height, height)
  end

  vim.api.nvim_win_set_config(0, { row = row, col = col, relative = "editor" })
end

function M.load(buf, opt)
  require("parse-keymap").add({
    ["<Esc>"] = {
      function()
        if opt.on_close then
          opt.on_close()
        end
      end,
      "n",
      { buffer = buf },
    },
    ["q"] = {
      function()
        if opt.on_close then
          opt.on_close()
        end
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-j>"] = {
      function()
        M.float_win_move("j", 2)
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-k>"] = {
      function()
        M.float_win_move("k", 2)
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-h>"] = {
      function()
        M.float_win_move("h", 2)
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-l>"] = {
      function()
        M.float_win_move("l", 2)
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-j>"] = {
      function()
        M.float_win_boundary_move("j")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-k>"] = {
      function()
        M.float_win_boundary_move("k")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-h>"] = {
      function()
        M.float_win_boundary_move("h")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-l>"] = {
      function()
        M.float_win_boundary_move("l")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-n>"] = {
      function()
        M.float_win_boundary_move("n")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-m>"] = {
      function()
        M.float_win_boundary_move("m")
      end,
      "n",
      { buffer = buf },
    },
    ["<C-M-space><C-M-space>"] = {
      function()
        M.float_win_boundary_move("c")
      end,
      "n",
      { buffer = buf },
    },
  })
end

return M
