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
    filter = opts.filter,
    capture = {},
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

local id

function M.active()
  if id then
    return
  end

  id = vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      for _, listener in ipairs(listeners.before) do
        listener(data)
      end
      for _, captures in pairs(capture_namespaces) do
        for _, capture in pairs(captures) do
          if capture.started then
            if (capture.filter and capture.filter(data)) or not capture.filter then
              capture.capture[#capture.capture + 1] = data
            end
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
  if not id then
    return
  end
  vim.api.nvim_del_autocmd(id)
  id = nil
end

--- @param callback fun()
function M.before(callback)
  table.insert(listeners.before, callback)
end

--- @param callback fun()
function M.after(callback)
  table.insert(listeners.after, callback)
end

return M
