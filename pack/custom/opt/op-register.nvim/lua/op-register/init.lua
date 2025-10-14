---@diagnostic disable: param-type-mismatch
local M = {}

local registers = {
  '"', -- 未命名寄存器
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9", -- 数字寄存器
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z", -- 命名寄存器
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z", -- 命名寄存器
  "-", -- 小删除寄存器
  "*",
  "+", -- 系统剪贴板寄存器
  "/", -- 搜索寄存器
  ":", -- 命令行寄存器
  "%",
  "#", -- 当前和上一个文件名
  "=", -- 表达式寄存器
}

function M.paste(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if not vim.tbl_contains(registers, char) then
    return
  end

  local count = vim.v.count1
  vim.schedule(function()
    vim.api.nvim_feedkeys(count .. '"' .. char .. operator, "n", false)
  end)
end

function M.copy(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if not vim.tbl_contains(registers, char) then
    return
  end
  local count = vim.v.count1
  vim.schedule(function()
    vim.api.nvim_feedkeys(count .. '"' .. char .. operator, "n", false)
  end)
end

function M.delete(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if not vim.tbl_contains(registers, char) then
    return
  end
  local count = vim.v.count1
  vim.schedule(function()
    vim.api.nvim_feedkeys(count .. '"' .. char .. operator, "n", false)
  end)
end

function M.delete_x(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if not vim.tbl_contains(registers, char) then
    return
  end
  local count = vim.v.count1
  vim.schedule(function()
    vim.api.nvim_feedkeys(count .. '"' .. char .. operator, "n", false)
  end)
end

function M.change(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if not vim.tbl_contains(registers, char) then
    return
  end
  local count = vim.v.count1
  vim.schedule(function()
    vim.api.nvim_feedkeys(count .. '"' .. char .. operator, "n", false)
  end)
end

return M
