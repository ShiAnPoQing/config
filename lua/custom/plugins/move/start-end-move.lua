local M = {}

local Key = {}

-- @param keymap table
local function get_keymap(keymap)
  if keymap.count == 26 then
    return {}
  end

  local random = math.random(26)
  local key = Key.keys:sub(random, random)
  local child = keymap.child

  if child[key] == nil then
    child[key] = {
      count = 0,
      key = key,
      child = {}
    }
    keymap.count = keymap.count + 1
    return child[key]
  else
    return get_keymap(keymap)
  end
end

local function more_key_set_extmark(keymap, child_keymap, i)
  vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
    virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
    virt_text_win_col = 0
  })
  child_keymap.jump_number = i
  child_keymap.reset_mark = function()
    vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
      virt_text = { { child_keymap.key, "HopNextKey" } },
      virt_text_win_col = 0
    })
  end
end

local function one_key_set_extmark(line)
  local keymap = get_keymap(Key.keymap)
  vim.api.nvim_buf_set_extmark(0, Key.keymap.ns_id, line, 0, {
    virt_text = { { keymap.key, "HopNextKey" } },
    virt_text_win_col = 0
  })
  keymap.jump_number = line + 1
end

local function clean_mark(all)
  vim.api.nvim_buf_clear_namespace(0, Key.keymap.ns_id, 0, -1)
  for k, value in pairs(Key.keymap.child) do
    if value.ns_id then
      vim.api.nvim_buf_clear_namespace(0, value.ns_id, 0, -1)
    end
  end
  if all then
    vim.api.nvim_buf_clear_namespace(0, Key.line_ns_id, 0, -1)
  end
end

local function on_key(keymap, LR)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    local child_keymap = keymap.child[char]
    if child_keymap then
      if child_keymap.callback then
        child_keymap.callback()
      end
      if child_keymap.jump_number then
        vim.api.nvim_feedkeys(child_keymap.jump_number .. "G^", "nx", false)
      end
    end

    clean_mark(true)
  end)
end


function Key:init()
  self.keymap = {
    count = 0,
    child = {},
    ns_id = vim.api.nvim_create_namespace("normal-custom")
  }
  self.up_break = nil
  self.down_break = nil
  self.line_ns_id = nil
  self.more_keymap = {}
  self.keys = "abcdefghijklmnopqrstuvwxyz"
end

function Key:collect_more_keys(line_count)
  local count = 0
  if line_count > 26 then
    count = math.ceil((line_count - 26) / 26)
  end

  for i = 1, count do
    local keymap = get_keymap(self.keymap)
    keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
    keymap.callback = function()
      clean_mark()
      keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
      for key, value in pairs(keymap.child) do
        value.reset_mark()
      end
      vim.cmd.redraw()
      on_key(keymap)
    end
    table.insert(Key.more_keymap, keymap)
  end
end

function Key:one_keys(topline, botline, cursor_row)
  local count = 0
  local not_key_can_be_use = function()
    if self.keymap.count == 26 then
      self.up_break = cursor_row - count
      self.down_break = cursor_row + count
    end
  end

  while true do
    if self.up_break ~= nil and self.down_break ~= nil then
      break
    end

    if not self.up_break then
      if cursor_row - count > topline - 1 then
        one_key_set_extmark(cursor_row - count - 1)
        not_key_can_be_use()
      else
        self.up_break = cursor_row - count
      end
    end

    if not self.down_break then
      if cursor_row + count < botline then
        one_key_set_extmark(cursor_row + count)
        not_key_can_be_use()
      else
        self.down_break = cursor_row + count
      end
    end
    count = count + 1
  end
end

local function process_more_key(i)
  local keymap, child_keymap = Key:get_more_key_keymap()
  more_key_set_extmark(keymap, child_keymap, i)
end

function Key:more_keys(topline, botline, cursor_row)
  if Key.up_break > 1 then
    for i = topline, Key.up_break - 1 do
      process_more_key(i)
    end
  end

  if Key.down_break <= botline then
    for i = Key.down_break + 1, botline do
      process_more_key(i)
    end
  end
end

function Key:get_more_key_keymap()
  local parent_keymap = self.more_keymap[1]
  if not parent_keymap then
    return {}, {}
  end
  if parent_keymap.count == 26 then
    table.remove(self.more_keymap, 1)
  end
  local keymap = get_keymap(parent_keymap)
  return parent_keymap, keymap
end

--- @param LR "left"|"right"
function M.start_end_move(LR)
  local count = vim.v.count1

  if LR == "left" then
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("^", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("0", "nx", false)
      end
    else
      -- local cursor = vim.api.nvim_win_get_cursor(0)
      -- local clear_namespace = set_extmark(LR, cursor, count)
      -- vim.schedule(function()
      --   local char = vim.fn.nr2char(vim.fn.getchar())
      --   if char == "j" then
      --     vim.api.nvim_feedkeys(count .. "+", "n", false)
      --   elseif char == "k" then
      --     vim.api.nvim_feedkeys(count .. "-", "n", false)
      --   end
      --   clear_namespace()
      -- end)
    end
  else
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(count .. "g_", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("$", "nx", false)
      end
    else
      -- local cursor = vim.api.nvim_win_get_cursor(0)
      -- local clear_namespace = set_extmark(LR, cursor, count)
      -- vim.schedule(function()
      --   local char = vim.fn.nr2char(vim.fn.getchar())
      --   if char == "j" then
      --     vim.api.nvim_feedkeys(count + 1 .. "g_", "n", false)
      --   elseif char == "k" then
      --     local up = vim.api.nvim_replace_termcodes("<up>", true, true, true)
      --     vim.api.nvim_feedkeys(count .. up .. "g_", "n", false)
      --   end
      --   clear_namespace()
      -- end)
    end
  end
end

--- @param LR "left" | "right"
function M.start_end_move_general(LR)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  Key:init()
  Key:collect_more_keys(botline - topline + 1)
  Key:one_keys(topline, botline, cursor_row)
  Key:more_keys(topline, botline, cursor_row)

  Key.line_ns_id = vim.api.nvim_create_namespace("line-custom")
  vim.api.nvim_buf_set_extmark(0, Key.line_ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched"
  })
  on_key(Key.keymap, LR)
end

return M
