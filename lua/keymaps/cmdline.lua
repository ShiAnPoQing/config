local function get_prev_word_start(callback)
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local base = cmd:find("%w")

  if not base then
    return
  end

  base = base - 1
  local new_pos = pos

  for value in cmd:gmatch("%w+%s*") do
    base = base + #value

    if base >= pos - 1 then
      new_pos = base - #value + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_next_word_end(callback)
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local base = 0
  local new_pos = pos
  for value in cmd:gmatch("%s*%w+") do
    base = base + #value

    if base >= pos then
      new_pos = base + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_next_word_start(callback)
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local base = cmd:find("%w")

  if not base then
    return
  end

  base = base - 1

  local new_pos = pos
  for value in cmd:gmatch("%w+%s*") do
    base = base + #value

    if base >= pos then
      new_pos = base + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

local function get_prev_word_end(callback)
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local base = 0
  local new_pos = pos
  for value in cmd:gmatch("%s*%w+") do
    base = base + #value

    if base >= pos - 1 then
      new_pos = base - #value + 1
      break
    end
  end

  if not new_pos then
    return
  end

  callback({
    cmd = cmd,
    pos = pos,
    new_pos = new_pos,
  })
end

return {
  ["<M-Space><M-h>"] = {
    function()
      local cmd = vim.fn.getcmdline()
      local _, new_pos = cmd:find("^%s*%w")

      if not new_pos then
        return
      end

      local pos = vim.fn.getcmdpos()
      vim.fn.setcmdline(cmd, new_pos == pos and 1 or new_pos)
    end,
    "c",
  },
  ["<M-Space><M-l>"] = {
    function()
      local cmd = vim.fn.getcmdline()
      local new_pos = cmd:find("%w%s*$")

      if not new_pos then
        return
      end

      local pos = vim.fn.getcmdpos()

      if new_pos + 1 == pos then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", true)
      else
        vim.fn.setcmdline(cmd, new_pos + 1)
      end
    end,
    "c",
  },
  ["<M-Space><M-Space><M-h>"] = {
    "<Home>",
    "c",
  },
  ["<M-Space><M-Space><M-l>"] = {
    "<End>",
    "c",
  },
  ["<M-o>"] = {
    function()
      get_next_word_end(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<M-i>"] = {
    function()
      get_prev_word_start(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<C-M-o>"] = {
    function()
      get_next_word_start(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<C-M-i>"] = {
    function()
      get_prev_word_end(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<M-Space><M-o>"] = {
    function()
      get_next_word_start(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<M-Space><M-i>"] = {
    function()
      get_prev_word_end(function(data)
        vim.fn.setcmdline(data.cmd, data.new_pos)
      end)
    end,
    "c",
  },
  ["<C-o>"] = {
    function()
      get_next_word_end(function(data)
        vim.fn.setcmdline(data.cmd:sub(1, data.pos - 1) .. data.cmd:sub(data.new_pos), data.pos)
      end)
    end,
    "c",
  },
  ["<C-i>"] = {
    "<C-w>",
    "c",
  },
  ["<C-Space><C-o>"] = {
    function()
      get_next_word_start(function(data)
        vim.fn.setcmdline(data.cmd:sub(0, data.pos - 1) .. data.cmd:sub(data.new_pos), data.pos)
      end)
    end,
    "c",
  },
  ["<C-Space><C-i>"] = {
    function()
      get_prev_word_end(function(data)
        vim.fn.setcmdline(data.cmd:sub(0, data.new_pos - 1) .. data.cmd:sub(data.pos), data.new_pos)
      end)
    end,
    "c",
  },
}
