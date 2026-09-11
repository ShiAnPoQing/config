local M = {}
M.__index = M

--- @param winrestcmd string
--- @param width_ratio number|nil
--- @param height_ratio number|nil
local function correct_winrestcmd(winrestcmd, width_ratio, height_ratio)
  if not width_ratio and not height_ratio then
    return winrestcmd
  end
  local cmds = vim.split(winrestcmd, "|")
  for i = 1, #cmds do
    local cmd = cmds[i]
    cmds[i] = cmd:gsub("%d+$", function(s)
      return math.ceil(tonumber(s) * (cmd:match("^vert") and width_ratio or height_ratio))
    end)
  end

  return table.concat(cmds, "|")
end

--- @param cmd string
function M:new(cmd)
  vim.validate("cmd", cmd, "string")
  local o = setmetatable({}, self)
  o.cmd = cmd
  return o
end

function M:exec()
  local win = vim.api.nvim_get_current_win()
  if not self.current then
    self.current = { win = win }
  elseif self.current.win ~= win or not vim.api.nvim_win_is_valid(self.current.win) then
    self:clean()
    self:exec()
    return
  end

  local old_winrestcmd = vim.fn.winrestcmd()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(self.cmd, true, false, true), "nx", true)
  local new_winrestcmd = vim.fn.winrestcmd()

  if old_winrestcmd ~= new_winrestcmd then
    --- maximize
    self.current.winrestcmd = old_winrestcmd
    local height = vim.api.nvim_win_get_height(win)
    local width = vim.api.nvim_win_get_width(win)
    local id = vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        local new_height = vim.api.nvim_win_get_height(win)
        local new_width = vim.api.nvim_win_get_width(win)
        self.current.height_ratio = new_height / height
        self.current.width_ratio = new_width / width
      end,
    })
    self.current.clean = function()
      vim.api.nvim_del_autocmd(id)
    end
  else
    --- reset
    self.current.winrestcmd =
      correct_winrestcmd(self.current.winrestcmd, self.current.width_ratio, self.current.height_ratio)
    vim.cmd(self.current.winrestcmd or "")
    self:clean()
  end
end

function M:clean()
  if self.current then
    if type(self.current.clean) == "function" then
      self.current.clean()
    end
    self.current = nil
  end
end

return M
