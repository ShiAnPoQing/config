local M = {}

--- @class ShellConnect.Request
--- @field action string
--- @field params table

--- @class ShellConnect.Response
--- @field id integer
--- @field ok boolean
--- @field payload table

local ZSH_NEOVIM_REQUEST_FILE = "/tmp/zsh-neovim-request"
local ZSH_NEOVIM_RESPONSE_FILE = "/tmp/zsh-neovim-response"
local request_id = 0
local pendings = {}

local function next_id()
  request_id = request_id + 1
  return request_id
end

local function had_response(sequence)
  return sequence:match("]777;zsh:neovim%-request:completed")
end

local function create_term_request(buf, channel)
  vim.api.nvim_chan_send(channel, "[28~")
  vim.api.nvim_create_autocmd("TermRequest", {
    once = true,
    buf = buf,
    callback = function(ev)
      local sequence = ev.data.sequence
      if not had_response(sequence) then
        return
      end
      local lines = vim.fn.readfile(ZSH_NEOVIM_RESPONSE_FILE)
      vim.fn.writefile("", ZSH_NEOVIM_RESPONSE_FILE)
      for _, line in ipairs(lines) do
        local ok, res = pcall(vim.json.decode, line)
        if ok then
          local pending = pendings[res.id]
          if pending then
            pending(res)
            pendings[res.id] = nil
          end
        end
      end
    end,
  })
end

--- @param buf integer
--- @param request ShellConnect.Request
--- @param handler? fun(response: ShellConnect.Response)
function M.request(buf, request, handler)
  vim.validate("buf", buf, "number")
  vim.validate("request", request, "table")
  request = request or {}
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  local channel = vim.bo[buf].channel
  if not channel then
    vim.api.nvim_echo({ { "Warn: ShellConnect.request must run in terminal buffer", "WarningMsg" } }, true)
    return
  end
  local channel_info = vim.api.nvim_get_chan_info(channel)
  local shell = channel_info.argv[1]
  if not vim.endswith(shell, "zsh") then
    return
  end
  local id = next_id()
  local ok, json = pcall(vim.json.encode, { action = request.action, params = request.params, id = id })
  if not ok then
    return
  end
  vim.fn.writefile({ json }, ZSH_NEOVIM_REQUEST_FILE, "a")
  if type(handler) == "function" then
    pendings[id] = handler
  end
  create_term_request(buf, channel)
end

return M
