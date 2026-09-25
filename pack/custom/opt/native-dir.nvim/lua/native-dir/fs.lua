local M = {}

--- @param path string
function M.create_parent_directory(path)
  local dirs = {}
  for dir in vim.fs.parents(path) do
    table.insert(dirs, 1, dir)
  end
  table.remove(dirs, 1)
  for _, name in ipairs(dirs) do
    if not vim.uv.fs_stat(name) then
      vim.uv.fs_mkdir(name, 493)
    end
  end
end

function M.is_empty_directory(path)
  local stat = vim.uv.fs_stat(path)

  if not stat or stat.type ~= "directory" then
    return nil
  end

  local req = vim.uv.fs_scandir(path)
  if not req then
    return nil
  end

  return vim.uv.fs_scandir_next(req) == nil
end

--- @param path string
--- @return boolean
function M.remove_directory(path)
  local req = vim.uv.fs_scandir(path)

  if not req then
    vim.schedule(function()
      vim.api.nvim_echo({ { "Could not scan dir " .. path, "ErrorMsg" } }, true)
    end)
    return false
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(req)
    if not name then
      break
    end

    local child = vim.fs.joinpath(path, name)

    if type == "directory" then
      local success = M.remove_directory(child)
      if not success then
        return false
      end
    else
      local success = vim.uv.fs_unlink(child)
      if not success then
        return false
      end
    end
  end

  return vim.uv.fs_rmdir(path) or false
end

return M
