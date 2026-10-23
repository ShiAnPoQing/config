--- @class my.atom._capture
local M = {}

local capture_namespaces = {}
local listeners = {
  before = {},
  after = {},
}

--- @param ns_id integer
--- @param id integer
--- @param opts? my.atom.start.Opts
function M.start(ns_id, id, opts)
  if not capture_namespaces[ns_id] then
    capture_namespaces[ns_id] = {}
  end
  capture_namespaces[ns_id][id] = {
    started = true,
    capture = {},
    patch = {},
  }
end

--- @param ns_id integer
--- @param id integer
function M.stop(ns_id, id)
  if not capture_namespaces[ns_id] then
    return
  end
  if not capture_namespaces[ns_id][id] then
    return
  end
  if not capture_namespaces[ns_id][id].started then
    return
  end
  capture_namespaces[ns_id][id] = nil
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(any)
function M.watch(ns_id, id, callback)
  if not capture_namespaces[ns_id] then
    return
  end
  if not capture_namespaces[ns_id][id] then
    return
  end
  if not capture_namespaces[ns_id][id].started then
    return
  end
  callback(capture_namespaces[ns_id][id].capture)
end

local cmdatom_id

function M.active()
  if cmdatom_id then
    return
  end

  cmdatom_id = vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      for _, listener in ipairs(listeners.before) do
        listener(data)
      end
      for _, captures in pairs(capture_namespaces) do
        for _, capture in pairs(captures) do
          if capture.started then
            for _, patch in ipairs(capture.patch) do
              data = patch(data)
            end
            capture.capture[#capture.capture + 1] = {
              buf = ev.buf,
              data = data,
            }
          end
        end
      end
      for _, listener in ipairs(listeners.after) do
        listener(data)
      end
    end,
  })
end

function M.deactive()
  if not cmdatom_id then
    return
  end
  vim.api.nvim_del_autocmd(cmdatom_id)
  cmdatom_id = nil
end

--- @param callback fun()
function M.before(callback)
  table.insert(listeners.before, callback)
end

--- @param callback fun()
function M.after(callback)
  table.insert(listeners.after, callback)
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(data:vim.event.cmdatom.data): vim.event.cmdatom.data
function M.patch(ns_id, id, callback)
  if not capture_namespaces[ns_id] then
    return
  end
  if not capture_namespaces[ns_id][id] then
    return
  end
  if not capture_namespaces[ns_id][id].started then
    return
  end
  table.insert(capture_namespaces[ns_id][id].patch, callback)
end

return M
