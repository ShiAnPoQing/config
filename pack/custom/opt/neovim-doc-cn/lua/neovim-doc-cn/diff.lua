local M = {}

local function get_neovim_doc_cn_path()
  local source = debug.getinfo(1, "S").source
  local path = source:sub(2)
  return vim.fn.fnamemodify(path, ":h:h:h") .. "/snapshot"
end

local function get_file_name(path)
  return vim.fn.fnamemodify(path, ":t:r")
end

---@return string[] | nil
local function get_neovim_docs()
  local paths = vim.api.nvim_get_runtime_file("doc", true)
  local neovim_doc_path
  for _, path in ipairs(paths) do
    if path:find("nvim/runtime/doc") then
      neovim_doc_path = path
      break
    end
  end

  if not neovim_doc_path then
    vim.notify("neovim doc path not found", vim.log.levels.ERROR)
    return
  end

  return vim.fn.globpath(neovim_doc_path, "*.txt", false, true)
end

local function get_neovim_cn_docs()
  local neovim_doc_path = get_neovim_doc_cn_path()
  return vim.fn.globpath(neovim_doc_path, "*", false, true)
end

function M.diff(input)
  local neovim_cn_docs = get_neovim_cn_docs()
  local neovim_docs = get_neovim_docs()
  if not neovim_docs then
    return
  end

  for i, neovim_cn_doc in ipairs(neovim_cn_docs) do
    local neovim_cn_doc_name = get_file_name(neovim_cn_doc)
    if input == neovim_cn_doc_name then
      local neovim_doc
      for _, doc in ipairs(neovim_docs) do
        local neovim_doc_name = get_file_name(doc)
        if neovim_cn_doc_name == neovim_doc_name then
          neovim_doc = doc
        end
      end
      if neovim_doc then
        local new_text = io.open(neovim_doc):read("*a")
        local old_text = io.open(neovim_cn_doc):read("*a")
        local result = vim.text.diff(old_text, new_text)
        if result == "" then
          vim.api.nvim_echo({ { "已是最新文档: " .. input, "WarningMsg" } }, true, {})
          return
        end
        return result
      end
    end
  end
  vim.api.nvim_echo({ { "未找到文档: " .. input, "ErrorMsg" } }, true, {})
end

return M
