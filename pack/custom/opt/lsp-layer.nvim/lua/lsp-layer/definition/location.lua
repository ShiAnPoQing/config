--- @class LspLayer.Definition.Location
--- @field result table
local M = {}

---@return LspLayer.Definition.PipelineLocationResult
function M:tolocation()
  local results = self.result.result
  local ctx = self.result.context
  local all_items = {}

  for client_id, res in pairs(results) do
    local client = assert(vim.lsp.get_client_by_id(client_id))
    local locations = {}
    if res then
      locations = vim.islist(res.result) and res.result or { res.result }
    end
    local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
    vim.list_extend(all_items, items)
  end

  local name = string.gsub(ctx.method:match("textDocument/(.*)"), "(%u)", " %1"):lower()
  if vim.tbl_isempty(all_items) then
    vim.notify(("No %s found"):format(name), vim.log.levels.INFO)
  end
  ---@type vim.fn.setqflist.what
  local list = {
    title = name:gsub("^%l", string.upper),
    items = all_items,
    context = { bufnr = ctx.bufnr, method = ctx.method },
  }
  --- @type LspLayer.Definition.PipelineLocationResult
  local result = {
    result = list,
    context = ctx,
    type = "location",
  }
  return result
end

return M
