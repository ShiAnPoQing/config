--- @class my._atom.marco
local M = {}
local enabled
--- @type string
local last_reg
--- @type integer
local ns_id
--- @type table<string, integer>|nil
local regs = {}

local function replay()
  ---@diagnostic disable-next-line: param-type-mismatch
  local reg = vim.fn.nr2char(vim.fn.getchar())
  if not reg then
    return
  end
  if reg == "@" then
    reg = last_reg
  else
    last_reg = reg
  end
  if regs[reg] then
    local id = regs[reg]
    my._atom.replay(ns_id, id)
  end
end

--- @param enable boolean?
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enable = enable ~= false
  if enabled == enable then
    return
  end
  enabled = enable
  if enable then
    --- @type string
    local reg
    --- @type my._atom.Capturer
    local Capturer
    ns_id = vim.api.nvim_create_namespace("my.atom.marco")
    local group = vim.api.nvim_create_augroup("my.atom.marco", { clear = true })
    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = group,
      callback = function()
        reg = vim.fn.reg_recording()
        if regs[reg] then
          my._atom.del(ns_id, regs[reg])
        end
        Capturer = my._atom.capturer()
        Capturer:start({
          filter = function(cmdAtom)
            return cmdAtom.cmd ~= "q"
          end,
          patch = function(cmdAtom)
            if (cmdAtom.type == "operator" or cmdAtom.type == "visual") and cmdAtom.keys:find("g@") then
              cmdAtom.keys = cmdAtom.keys:gsub(
                "g@",
                vim.keycode("<cmd>lua my.operator._pending_delete_({ reg = vim.v.register })<cr>") .. "g@"
              )
            end
            return cmdAtom
          end,
        })
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = group,
      callback = function()
        Capturer:stop(function(capture)
          if #capture.atoms > 0 then
            regs[reg] = my._atom.create(ns_id, capture)
          end
        end)
      end,
    })
    vim.keymap.set("n", "@", function()
      replay()
    end)
  else
    vim.api.nvim_del_augroup_by_name("my.atom.macro")
    ---@diagnostic disable-next-line: cast-local-type
    last_reg = nil
    regs = nil
    ---@diagnostic disable-next-line: cast-local-type
    ns_id = nil
    pcall(vim.keymap.del, "n", "@")
  end
end

--- @return boolean
function M.is_enabled()
  return not (enabled ~= true)
end

return M
