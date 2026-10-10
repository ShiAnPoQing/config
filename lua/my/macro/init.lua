--- @class my.macro
local M = {}

local enabled = false
local records = {}

local function _enable()
  local group = vim.api.nvim_create_augroup("my.macro", { clear = true })
  local reg
  local id
  vim.api.nvim_create_autocmd("RecordingEnter", {
    group = group,
    callback = function()
      reg = vim.fn.reg_recording()
      local atoms = {}
      records[tostring(reg)] = atoms
      id = vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function(ev)
          local data = ev.data --[[@as vim.event.cmdatom.data]]
          if vim.fn.getcmdwintype() == "" then
            atoms[#atoms + 1] = data
          end
        end,
      })
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = group,
    callback = function()
      local atoms = records[tostring(reg)] or {}
      vim.print(atoms)
      if atoms[1] and atoms[1].cmd == "q" then
        table.remove(atoms, 1)
      end
      vim.api.nvim_del_autocmd(id)
    end,
  })
end

local function _disable()
  vim.api.nvim_del_augroup_by_name("my.macro")
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
    _enable()
  else
    _disable()
  end
end

local last_reg

local function _repeat(reg)
  if not reg then
    return
  end

  if reg == "@" then
    reg = last_reg
  else
    last_reg = reg
  end
  local count = vim.v.count1
  for _ = 1, count do
    for _, atom in ipairs(records[reg] or {}) do
      if not atom.keys and atom.lhs then
        -- ISSUE: I don't know g@
        local fix = atom.lhs:find("lua my.operator", 1, true)
        if fix then
          atom.keys = vim.keycode("<Cmd>") .. atom.lhs:sub(fix, #atom.lhs - 1) .. vim.keycode("<Cr>")
          atom.lhs = nil
        end
      end
      vim.api.nvim_feedkeys(atom.keys or atom.lhs, atom.keys and "nt" or "mt", false)
    end
  end
end

function M._repeat()
  ---@diagnostic disable-next-line: param-type-mismatch
  _repeat(vim.fn.nr2char(vim.fn.getchar()))
end

--- @return boolean
function M.is_enabled()
  return enabled
end

return M
