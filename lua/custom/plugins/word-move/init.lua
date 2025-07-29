local R = require("repeat")
local K = require("plugin-keymap")
local M = {}

local function space_o()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    vim.api.nvim_exec2(string.format([[execute "normal! v%dw"]], count), {})
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dwh"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "w", "n", false)
end

local function space_i()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    vim.api.nvim_exec2(string.format([[execute "normal! hv%dge"]], count), {})
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dgel"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "ge", "n", false)
end

local function space_I()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dgEl"]], count), {})
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dgE"]], count), {})
    vim.api.nvim_exec2(string.format([[execute "normal! hv%dgE"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "gE", "n", false)
end

local function space_O()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dWh"]], count), {})
    vim.api.nvim_exec2(string.format([[execute "normal! v%dW"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "W", "n", false)
end

local function i()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%db"]], count), {})
    vim.api.nvim_exec2(string.format([[execute "normal! hv%db"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "b", "n", true)
end

local function o()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    vim.api.nvim_exec2(string.format([[execute "normal! v%de"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "e", "n", true)
end

local function I()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    -- vim.api.nvim_exec2(string.format([[execute "normal! v%dB"]], count), {})
    vim.api.nvim_exec2(string.format([[execute "normal! hv%dB"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "B", "n", true)
end

local function O()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1
  if mode == "no" then
    vim.api.nvim_exec2(string.format([[execute "normal! v%dE"]], count), {})
    return
  end
  vim.api.nvim_feedkeys(count .. "E", "n", true)
end

function M.space_o()
  space_o()
  R.Record(space_o)
end

function M.space_i()
  space_i()
  R.Record(space_i)
end

function M.space_I()
  space_I()
  R.Record(space_I)
end

function M.space_O()
  space_O()
  R.Record(space_O)
end

function M.i()
  i()
  R.Record(i)
end

function M.o()
  o()
  R.Record(o)
end

function M.I()
  I()
  R.Record(I)
end

function M.O()
  O()
  R.Record(O)
end

function M.setup()
  K.add(require("custom.plugins.word-move.keymaps"))
end

return M
