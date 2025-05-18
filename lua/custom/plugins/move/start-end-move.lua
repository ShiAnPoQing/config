local M = {}

local Key = {}

local function on_key(keymap)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    local child_keymap = keymap.child[char]
    if child_keymap then
      child_keymap.callback()
    end
  end)
end

local function clean_mark()

end

function Key:init()
  self.keymap = {
    count = 0,
    child = {}
  }
  self.more_keymap = {}
  self.keys = "abcdefghijklmnopqrstuvwxyz"
end

function Key:collect_more_keys(line_count)
  local count = 0
  if line_count > 26 then
    count = math.ceil((line_count - 26) / 26)
  end

  for i = 1, count do
    local keymap = Key:get_keymap(self.keymap)
    keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
    keymap.callback = function()
      on_key(keymap)
      clean_mark()
    end
    table.insert(Key.more_keymap, keymap)
  end
end

function Key:one_keys(topline, botline, cursor_row)
  local ns_id = vim.api.nvim_create_namespace("normal-custom")
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
        local keymap = self:get_keymap(self.keymap)
        vim.api.nvim_buf_set_extmark(0, ns_id, cursor_row - 1 - count, 0, {
          virt_text = { { keymap.key, "HopNextKey" } },
          virt_text_win_col = 0
        })
        keymap.ns_id = ns_id
        keymap.jump_count = count
        keymap.callback = function()
          if keymap.jump_count > 0 then
            vim.api.nvim_feedkeys(keymap.jump_count .. "k", "nx", false)
          end
        end
        not_key_can_be_use()
      else
        self.up_break = cursor_row - count
      end
    end

    if not self.down_break then
      if cursor_row + count < botline then
        local keymap = self:get_keymap(self.keymap)
        vim.api.nvim_buf_set_extmark(0, ns_id, cursor_row + count, 0, {
          virt_text = { { keymap.key, "HopNextKey" } },
          virt_text_win_col = 0
        })
        keymap.ns_id = ns_id
        keymap.jump_count = count
        keymap.callback = function()
          vim.api.nvim_feedkeys(keymap.jump_count + 1 .. "j", "nx", false)
        end
        not_key_can_be_use()
      else
        self.down_break = cursor_row + count
      end
    end
    count = count + 1
  end
end

function Key:more_keys(topline, botline, cursor_row)
  if Key.up_break > 2 then
    for i = topline, Key.up_break - 1 do
      local keymap, child_keymap = self:get_more_key_keymap()
      child_keymap.jump_count = cursor_row - i
      child_keymap.callback = function()
        if child_keymap.jump_count > 0 then
          vim.api.nvim_feedkeys(child_keymap.jump_count .. "k", "nx", false)
        end
      end

      vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
        virt_text = { { keymap.key, "HopNextKey" } },
        virt_text_win_col = 0
      })

      vim.api.nvim_buf_set_extmark(0, child_keymap.ns_id, i - 1, 0, {
        virt_text = { { child_keymap.key, "HopNextKey" } },
        virt_text_win_col = 1
      })
    end
  end

  if Key.down_break <= botline then
    for i = Key.down_break + 2, botline do
      local keymap, child_keymap = self:get_more_key_keymap()
      vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
        virt_text = { { keymap.key, "HopNextKey" } },
        virt_text_win_col = 0
      })
      vim.api.nvim_buf_set_extmark(0, child_keymap.ns_id, i - 1, 0, {
        virt_text = { { child_keymap.key, "HopNextKey" } },
        virt_text_win_col = 1
      })
      child_keymap.jump_count = i - cursor_row
      child_keymap.callback = function()
        if child_keymap.jump_count > 0 then
          vim.api.nvim_feedkeys(child_keymap.jump_count .. "j", "nx", false)
        end
      end
    end
  end
end

function Key:get_more_key_keymap()
  local parent_keymap = self.more_keymap[1]
  if not parent_keymap then
    return {}, {}
  end

  local keymap = self:get_keymap(parent_keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(parent_keymap.key .. keymap.key .. "-custom")

  if parent_keymap.count == 26 then
    table.remove(self.more_keymap, 1)
  end

  return parent_keymap, keymap
end

-- @param keymap table
function Key:get_keymap(keymap)
  if keymap.count == 26 then
    return {}
  end

  local random = math.random(26)
  local key = self.keys:sub(random, random)
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
    return self:get_keymap(keymap)
  end
end

--- @param LR "left"|"right"
function M.start_end_move(LR)

end

function M.start_end_move_general()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]

  Key:init()
  Key:collect_more_keys(botline - topline + 1)
  Key:one_keys(topline, botline, cursor_row)
  Key:more_keys(topline, botline, cursor_row)

  local ns_id = vim.api.nvim_create_namespace("line-custom")
  vim.api.nvim_buf_set_extmark(0, ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched"
  })
  on_key(Key.keymap)
end

return M
