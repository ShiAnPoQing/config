local fs = require("native-dir.fs")
local Dir = require("native-dir.dir")

local FILTERS = {
  ["."] = function(buf)
    local names = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
    local new_names = {}
    for _, name in ipairs(names) do
      if not name:match("^%.") then
        table.insert(new_names, name)
      end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, new_names)
  end,
}

--- @class NativeDir.Buffer
--- @field buf integer
--- @field ns integer
--- @field filters string[]
local M = {}
M.__index = M

--- @class NativeDir.Buffer.Opts
--- @field buf integer
--- @field ns integer

--- @param opts NativeDir.Buffer.Opts
function M.new(opts)
  opts = opts or {}
  local o = setmetatable({ ns = opts.ns, buf = opts.buf, filters = {} }, M)
  o:init()
  return o
end

function M:init()
  local buf = self.buf
  local dir = vim.api.nvim_buf_get_name(buf)
  local win = vim.api.nvim_get_current_win()
  local a = vim.fn.fnamemodify(dir, ":~")
  vim.wo[win][0].winbar = "%#Directory#" .. a .. ""
  vim.keymap.set("n", ".", function()
    local had_filter
    local removes = {}
    for i, filter in ipairs(self.filters) do
      if filter == "." then
        had_filter = true
        table.insert(removes, 1, i)
      end
    end
    if not had_filter then
      table.insert(self.filters, ".")
    else
      for _, i in ipairs(removes) do
        table.remove(self.filters, i)
      end
    end
    Dir.reload()
  end, { buf = buf })

  vim.keymap.set("n", "m", function()
    vim.ui.input({
      prompt = "Create New File/Folder: " .. dir,
    }, function(input)
      if not input or input == "" then
        return
      end
      local success = function(path)
        vim.schedule(function()
          vim.api.nvim_echo({
            { "Successfully created: " },
            { path, "WarningMsg" },
          }, true, {})
        end)
      end
      local path = vim.fs.normalize(input)
      if vim.endswith(input, "/") or vim.endswith(input, "\\") then
        fs.create_parent_directory(vim.fs.dirname(path) .. "/")
        vim.uv.fs_mkdir(vim.fs.basename(path), 493)
        success(vim.fs.joinpath(dir, path))
      else
        fs.create_parent_directory(path)
        local open_mode = vim.uv.constants.O_WRONLY + vim.uv.constants.O_CREAT + vim.uv.constants.O_EXCL
        local fd = vim.uv.fs_open(path, open_mode, 420)
        if fd then
          vim.uv.fs_close(fd)
          success(vim.fs.joinpath(dir, path))
        else
          if not vim.uv.fs_stat(path) then
            vim.schedule(function()
              vim.api.nvim_echo({ { "Could not create file " .. path, "ErrorMsg" } }, true)
            end)
          else
            vim.schedule(function()
              vim.api.nvim_echo({ { "File already exists: " .. path, "ErrorMsg" } }, true)
            end)
          end
        end
      end
      Dir.reload()
    end)
  end, { buf = buf })

  vim.keymap.set("n", "r", function()
    local name = vim.api.nvim_get_current_line()
    local source = vim.fs.joinpath(dir, (name:gsub("/$", "")))
    local prompt = "Rename " .. source .. "  "
    local row = vim.o.lines - ((vim.o.cmdheight == 0) and 1 or vim.o.cmdheight) + 1
    vim.g.ui_cmdline_pos = { row, vim.fn.strdisplaywidth(prompt) - 1 }
    vim.ui.input({
      prompt = prompt,
      default = dir,
      completion = "file",
    }, function(input)
      vim.g.ui_cmdline_pos = nil
      if not input or input == "" then
        return
      end
      local dest = vim.fs.normalize(input)
      fs.create_parent_directory(vim.fs.dirname(dest) .. "/")
      vim.uv.fs_rename(source, dest, function(err)
        if err then
          vim.schedule(function()
            vim.api.nvim_echo({
              { "Could not move the files from '" .. source .. "' to " .. "'" .. dest .. "'", "ErrorMsg" },
            }, true)
          end)
          return
        end
        vim.schedule(function()
          vim.api.nvim_echo({
            { "Successfully renamed: from " },
            { source, "WarningMsg" },
            { " to ", "Normal" },
            { vim.fs.normalize(vim.fs.joinpath(dir, input)), "WarningMsg" },
          }, true, {})
          Dir.reload()
        end)
      end)
    end)
  end, { buf = buf })

  vim.keymap.set("o", "d", function()
    if vim.v.operator == "d" then
      local name = vim.api.nvim_get_current_line()
      local path = vim.fs.joinpath(dir, (name:gsub("/$", "")))
      if vim.fn.isdirectory(path) == 1 then
        if fs.is_empty_directory(path) then
          fs.remove_directory(path)
          Dir.reload()
        else
          vim.ui.select({ "Yes", "No" }, {
            prompt = 'Delete directory "' .. path .. '" and all items?',
          }, function(choice)
            if choice == "Yes" then
              fs.remove_directory(path)
              Dir.reload()
            end
          end)
        end
      else
        vim.schedule(function()
          vim.ui.select({ "Yes", "No" }, {
            prompt = "Delete " .. "'" .. path .. "'" .. "?",
          }, function(choice)
            if choice == "Yes" then
              local ok = vim.uv.fs_unlink(path)
              if not ok then
                vim.schedule(function()
                  vim.api.nvim_echo({ { "Could not remove file: " .. path, "ErrorMsg" } }, true)
                end)
              else
                vim.schedule(function()
                  vim.api.nvim_echo({ { "Successfully deleted " .. "'" .. path .. "'", "WarningMsg" } }, true)
                end)
                Dir.reload()
              end
            end
          end)
        end)
      end
    end
    return "<esc>"
  end, { expr = true, buf = buf })

  vim.keymap.set("v", "d", function()
    local mode = vim.fn.mode()
    if mode ~= "V" then
      return
    end
    local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
    vim.print(region)
  end, { buf = buf })

  vim.keymap.set("n", "p", function()
    local name = vim.api.nvim_get_current_line()
    local path = vim.fs.joinpath(dir, (name:gsub("/$", "")))
    local ext = vim.fs.ext(name)
    local type = "file"
    if ext == "png" then
      type = "image"
    end
    local Preview = require("native-dir.preview")
    if Preview.is_open() then
      Preview.close()
    else
      Preview.open({ file = path, type = type }, {
        image = {},
        window = {
          win = {
            title = name,
            title_pos = "center",
          },
        },
      })
    end
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = buf,
      callback = function()
        Preview.close()
        return true
      end,
    })
  end, { buf = buf })
end

function M:reload()
  if #self.filters > 0 then
    for _, filter in ipairs(self.filters) do
      if FILTERS[filter] then
        FILTERS[filter](self.buf)
      end
    end
  end
end

return M

-- local buf_win_entered
-- local buf_win_enter_id = vim.api.nvim_create_autocmd("BufWinEnter", {
--   callback = function(ev)
--     if ev.buf == buf then
--       buf_win_entered = true
--     end
--   end,
-- })
-- local cursor_moved_id = vim.api.nvim_create_autocmd("CursorMoved", {
--   buf = buf,
--   callback = function()
--     if vim.fn.line("w0") == 1 and buf_win_entered then
--       buf_win_entered = false
--       U.feedkey(CTRL_Y)
--       return
--     end
--     local line = vim.fn.line(".")
--     if line == 1 then
--       U.feedkey(CTRL_Y)
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd("BufDelete", {
--   buf = buf,
--   callback = function()
--     pcall(vim.api.nvim_del_augroup_by_id, buf_win_enter_id)
--     pcall(vim.api.nvim_del_augroup_by_id, cursor_moved_id)
--     return true
--   end,
-- })
