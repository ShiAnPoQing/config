--- @return string
local function get_id(data)
  local id = ""
  if #data.semantic_tokens > 0 then
    id = id .. "semantic_tokens:"
    for _, token in ipairs(data.semantic_tokens) do
      id = id .. token.id
    end
  end

  if #data.treesitter > 0 then
    id = id .. "treesitter:"
    for _, capture in ipairs(data.treesitter) do
      id = id .. capture.id
    end
  end

  if #data.extmarks > 0 then
    id = id .. "extmarks:"
    for _, capture in ipairs(data.extmarks) do
      id = id .. capture.id
    end
  end

  return id
end

--- @param ns_id integer
--- @param hl_group string
--- @return vim.api.keyset.get_hl_info
local function get_hl_info(ns_id, hl_group)
  local info = vim.api.nvim_get_hl(ns_id, {
    name = hl_group,
    link = false,
  })
  if vim.tbl_isempty(info) then
    info = vim.api.nvim_get_hl(0, {
      name = hl_group,
      link = false,
    })
  end
  if info.link == hl_group then
    info.link = nil
  end
  return info
end

--- @param hl_info table
--- @return string
local function create_hl_group(hl_info)
  local parts = {}
  for k, v in pairs(hl_info) do
    parts[#parts + 1] = ("%s_%s"):format(k, tostring(v))
  end
  local name = table.concat(parts, "_")
  vim.api.nvim_set_hl(0, name, hl_info)
  return name
end

--- @return string
local function compute_hl_group(data)
  if #data.semantic_tokens > 0 then
    table.sort(data.semantic_tokens, function(a, b)
      return a.opts.priority < b.opts.priority
    end)
    local hl_info = {}
    for _, token in ipairs(data.semantic_tokens) do
      local ns_id = token.opts.ns_id
      hl_info = vim.tbl_extend("force", hl_info, get_hl_info(ns_id, token.opts.hl_group_link or token.opts.hl_group))
    end
    if vim.tbl_count(hl_info) > 0 then
      return create_hl_group(hl_info)
    end
  end

  if #data.treesitter > 0 then
    local hl_info = {}
    for _, token in ipairs(data.treesitter) do
      hl_info = vim.tbl_extend("force", hl_info, get_hl_info(0, token.hl_group_link or token.hl_group))
    end
    if vim.tbl_count(hl_info) > 0 then
      return create_hl_group(hl_info)
    end
  end

  return "Folded"
end

--- @param results [string, string][]
--- @param start_text string
--- @param lnum integer
local function fold_virt_text(results, start_text, lnum)
  local buf = vim.api.nvim_get_current_buf()
  local pre_id
  local result = {}

  for i = 1, #start_text do
    local data = vim.inspect_pos(buf, lnum, i - 1)
    local char = start_text:sub(i, i)
    local id = get_id(data)
    if id == pre_id then
      result[1] = result[1] .. char
    else
      if #result == 2 then
        table.insert(results, result)
      end
      result = { char, compute_hl_group(data) }
    end

    if i == #start_text then
      table.insert(results, result)
    end

    pre_id = id
  end
end

function _G.custom_foldtext()
  local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  --- @type [string, string][]
  local results = {}
  fold_virt_text(results, start_text, vim.v.foldstart - 1)
  table.insert(results, { "  ", nil })
  table.insert(results, { "󰛁  " .. nline .. " lines folded", "@comment" })
  return results
end

vim.go.foldcolumn = "auto"
vim.go.foldmethod = "expr"
vim.go.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 打开文件时启用折叠
vim.go.foldenable = true
-- 默认展开所有
vim.go.foldlevel = 99
-- 打开文件时不折叠
vim.o.foldlevelstart = 99
-- 最大嵌套折叠层数
vim.go.foldnestmax = 20
vim.go.foldtext = "v:lua.custom_foldtext()"
