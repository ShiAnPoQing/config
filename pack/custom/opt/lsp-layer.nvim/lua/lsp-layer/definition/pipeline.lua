---@class LspLayer.Definition.Pipeline
---@field queue (fun():any)[]
---@field result LspLayer.Definition.PipelineSourceResult
local M = {}

---@alias LspLayer.Definition.PipelineResult
--- | LspLayer.Definition.PipelineLocationResult
--- | LspLayer.Definition.PipelineSourceResult

---@class LspLayer.Definition.PipelineLocationResult
---@field type "location"
---@field result vim.fn.setqflist.what
---@field context table

---@class LspLayer.Definition.PipelineSourceResult
---@field type "source"
---@field result table
---@field context table

---@param results any
---@param context table
function M:receive(results, context)
  self.result = {
    type = "source",
    result = results,
    context = context,
  }
  for _, r in ipairs(self.queue) do
    self.result = r()
  end
end

---@param callback fun(): any
function M:push(callback)
  self.queue[#self.queue + 1] = callback
end

return M
