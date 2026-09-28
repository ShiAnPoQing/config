--- @class my.multicursor.register
local M = {}

local enabled
local ns_id
local group_id

local function _disable()
  vim.on_key(nil, ns_id)
  vim.api.nvim_del_augroup_by_id(group_id)
end

local function _enable()
  ns_id = vim.api.nvim_create_namespace("multicursor.register")
  group_id = vim.api.nvim_create_augroup("multicursor.register", { clear = true })
  vim.on_key(function()
    if my.multicursor.active() then
      my.multicursor.snapshot(0)
    end
  end, ns_id)

  local multicursor_yanks = {}
  local snapshot

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group_id,
    callback = function()
      if my.multicursor.active() and vim.v.event.operator == "y" and vim.v.event.regname == "" then
        if #multicursor_yanks == 0 then
          snapshot = my.multicursor.get_snapshot(0)
        end
        table.insert(multicursor_yanks, {
          regname = vim.v.event.regname,
          regtype = vim.v.event.regtype,
          operator = vim.v.event.operator,
          regcontents = vim.v.event.regcontents,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("CmdAtom", {
    group = group_id,
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      if data.operator == "y" and snapshot then
        local ok = true
        local regname
        for _, yank in ipairs(multicursor_yanks) do
          if not regname then
            regname = yank.regname
          end
          if yank.regname ~= regname then
            ok = false
          end
          if yank.operator ~= "y" then
            ok = false
          end
        end
        if ok and regname then
          local snapshot_sort_by_id = vim.tbl_extend("force", {}, snapshot)
          table.sort(snapshot_sort_by_id, function(a, b)
            return a[1] < b[1]
          end)
          for i, yank in ipairs(multicursor_yanks) do
            snapshot_sort_by_id[i].data = yank
          end
          local snapshot_sort_by_row = vim.tbl_extend("force", {}, snapshot_sort_by_id)
          table.sort(snapshot_sort_by_row, function(a, b)
            return a[2] < b[2]
          end)
          local content = ""
          for _, value in ipairs(snapshot_sort_by_row) do
            content = content .. vim.fn.join(value.data.regcontents, "\n") .. "\n"
          end
          vim.fn.setreg(regname, content)
          local clipboard = vim.opt.clipboard:get()
          clipboard = type(clipboard) == "table" and clipboard or {}
          for _, type in ipairs(clipboard) do
            if type == "unnamedplus" then
              vim.fn.setreg("+", content)
            elseif type == "unnamed" then
              vim.fn.setreg("*", content)
            end
          end
        end
        snapshot = nil
        multicursor_yanks = {}
      end
    end,
  })
end

--- @param enable boolean?
function M.enable(enable)
  enable = enable == nil and true or enable
  if enable then
    if enabled then
      return
    end
    _enable()
  else
    if not enabled then
      return
    end
    _disable()
  end
end

return M
