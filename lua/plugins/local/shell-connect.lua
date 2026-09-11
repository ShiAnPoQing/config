local word_regex = vim.regex("\\k\\+\\|[^[:keyword:][:space:]]\\+")
local WORD_regex = vim.regex("\\S\\+")

--- function to match regex and callback
local function match(regex, str, callback)
  local function run(s)
    local start, _end = regex:match_str(s)
    if start == nil then
      return
    end
    if callback(#str - #s + start, #str - #s + _end) then
      return
    end
    run(s:sub(_end + 1))
  end

  run(str)
end

local function get_new_cmdpos(regex, cmdline, callback)
  local new_cmdpos
  match(regex, cmdline, function(start, _end)
    local may_new_cmdpos, is_finished = callback(start + 1, _end)
    if type(may_new_cmdpos) == "number" then
      new_cmdpos = may_new_cmdpos
    end
    return is_finished
  end)
  return new_cmdpos
end

local function delete_to_prev_word_start(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos > start then
      return start
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  return { buffer = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos), cursor = new_cmdpos }
end

local function delete_to_next_word_end(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos <= _end then
      return _end + 1, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  return { buffer = new_cmdline, cursor = cmdpos - 1 }
end

local function delete_to_prev_word_end(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  return { buffer = new_cmdline, cursor = new_cmdpos }
end

local function delete_to_next_word_start(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(word_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  return { buffer = new_cmdline, cmdpos }
end

local function delete_to_prev_WORD_end(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(_, _end)
    if cmdpos > _end + 1 then
      return _end + 1
    end
  end)
  if not new_cmdpos then
    new_cmdpos = 1
  end
  local new_cmdline = cmdline:sub(1, new_cmdpos - 1) .. cmdline:sub(cmdpos)
  return { buffer = new_cmdline, cursor = new_cmdpos }
end

local function delete_to_next_WORD_start(cmdline, cmdpos)
  cmdpos = cmdpos + 1
  local new_cmdpos = get_new_cmdpos(WORD_regex, cmdline, function(start, _)
    if cmdpos < start then
      return start, true
    end
  end)
  if not new_cmdpos then
    new_cmdpos = #cmdline
  end
  local new_cmdline = cmdline:sub(1, cmdpos - 1) .. cmdline:sub(new_cmdpos)
  return { buffer = new_cmdline, cursor = cmdpos }
end

return {
  name = "shell-connect.nvim",
  key = {
    ["<C-i>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_prev_word_start(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the start of the previous word",
    },
    ["<C-o>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_next_word_end(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the end of the next word",
    },
    ["<C-space><C-i>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_prev_word_end(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the end of the previous word",
    },
    ["<C-space><C-o>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_next_word_start(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the start of the next word",
    },
    ["<C-S-i>"] = { "<C-w>", "t", desc = "Delete up to the start of the previous WORD" },
    ["<C-S-o>"] = { "<M-d>", "t", desc = "Delete up to the end of the next WORD" },
    ["<C-space><C-S-i>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_prev_WORD_end(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the end of the previous WORD",
    },
    ["<C-S-space><C-S-i>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_prev_WORD_end(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the end of the previous WORD",
    },
    ["<C-space><C-S-o>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_next_WORD_start(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the start of the next WORD",
    },
    ["<C-S-space><C-S-o>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = delete_to_next_WORD_start(buffer, cursor),
          })
        end)
      end,
      "t",
      desc = "Delete up to the start of the next WORD",
    },
    ["<M-space><M-l>"] = { "<M-space><M-l>", "t", desc = "Move to the last non-blank character" },
    ["<M-space><M-h>"] = { "<M-space><M-h>", "t", desc = "Move to the first non-blank character" },
    ["<M-space><M-space><M-l>"] = { "<End>", "t", desc = "<End>" },
    ["<M-space><M-space><M-h>"] = { "<Home>", "t", desc = "<Home>" },

    ["<M-i>"] = { "<M-b>", "t", desc = "Move to prev-word-start" },
    ["<M-o>"] = {
      function()
        require("shell-connect").request(0, {
          action = "get-prompt-state",
          params = {},
        }, function(data)
          local buffer = data.payload.buffer
          local cursor = data.payload.cursor

          cursor = cursor + 1
          local new_cmdpos = get_new_cmdpos(word_regex, buffer, function(_, _end)
            if cursor <= _end then
              return _end + 1, true
            end
          end)
          if not new_cmdpos then
            new_cmdpos = #buffer + 1
          end
          require("shell-connect.core").request(0, {
            action = "set-prompt-state",
            params = { cursor = new_cmdpos - 1 },
          })
        end)
      end,
      "t",
      desc = "Move to next-word-end",
    },
  },
}
