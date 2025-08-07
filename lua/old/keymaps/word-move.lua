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

return {
  -- For insert mode: like <M-d><M-o>
  ["<M-o>"] = {
    o,
    "o",
  },
  -- For insert mode: like <M-d><M-i>
  ["<M-i>"] = {
    i,
    "o",
  },
  ["i"] = {
    i,
    { "n", "x", "o" },
  },
  ["o"] = {
    o,
    { "n", "x", "o" },
  },
  ["I"] = {
    I,
    { "n", "x", "o" },
  },
  ["O"] = {
    O,
    { "n", "x", "o" },
  },
  ["<space>i"] = {
    space_i,
    { "n", "x", "o" },
  },
  ["<space>o"] = {
    space_o,
    { "n", "x", "o" },
  },
  ["<space>I"] = {
    space_I,
    { "n", "x", "o" },
  },
  ["<space>O"] = {
    space_O,
    { "n", "x", "o" },
  },
}
