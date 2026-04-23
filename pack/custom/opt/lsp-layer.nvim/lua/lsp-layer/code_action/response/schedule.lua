---@class LspLayer.CodeAction.Schedule
---@field queue (fun():any)[]
---@field response LspLayer.CodeAction.Action[]
local M = {}

---@class LspLayer.CodeAction.Action
---@field action lsp.Command|lsp.CodeAction
---@field ctx lsp.HandlerContext

---@param response any
---@param opts LspLayer.CodeActionOpts
function M:receive(response, opts)
  local results = response
  local function action_filter(a)
    -- filter by specified action kind
    if opts and opts.context then
      if opts.context.only then
        if not a.kind then
          return false
        end
        local found = false
        for _, o in ipairs(opts.context.only) do
          -- action kinds are hierarchical with . as a separator: when requesting only 'type-annotate'
          -- this filter allows both 'type-annotate' and 'type-annotate.foo', for example
          if a.kind == o or vim.startswith(a.kind, o .. ".") then
            found = true
            break
          end
        end
        if not found then
          return false
        end
      end
      -- Only show disabled code actions when the trigger kind is "Invoked".
      if a.disabled and opts.context.triggerKind ~= vim.lsp.protocol.CodeActionTriggerKind.Invoked then
        return false
      end
    end
    -- no filter removed this action
    return true
  end
  ---@type LspLayer.CodeAction.Action[]
  local actions = {}
  for _, result in pairs(results) do
    for _, action in pairs(result.result or {}) do
      if action_filter(action) then
        table.insert(actions, { action = action, ctx = result.context })
      end
    end
  end
  self.response = actions
  for _, r in ipairs(self.queue) do
    self.response = r()
  end
end

---@param callback fun(): any
function M:push(callback)
  self.queue[#self.queue + 1] = callback
end

return M
