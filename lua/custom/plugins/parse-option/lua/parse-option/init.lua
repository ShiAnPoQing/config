local M = {}

--- @class NeovimOptionsSetupParam
--- @field paths table<string>

local OPTIONS = {}

local option_count = 0
local function print_ok(name)
  -- option_count = option_count + 1
  -- print(name, vim.inspect(vim.opt[name]:get()))
  -- print('-----------------------')
end

local function notify(name, value)
  local msg = [[
if you want append option
you should do like this:

  append = {
    ${name} = { ${value} }
  }

if you want replace the whole option
yout should do like this:

  ${name} = { ${value} }

    ]]
  vim.notify(msg:gsub("%${name}", name):gsub("%${value}", value))
end

local function iter_filetype(source)
  for key, options in pairs(source) do
    if OPTIONS[key] ~= nil and type(OPTIONS[key]) == "table" then
      OPTIONS[key] = vim.tbl_extend("force", OPTIONS[key], options)
    else
      OPTIONS[key] = vim.tbl_extend("force", {}, options)
    end
  end
end

local function get_option_type(name)
  return type(vim.opt[name]:get())
end

local function append_options(source)
  for name, value in pairs(source) do
    local opt_type = get_option_type(name)
    if opt_type ~= "table" then
      break
    end

    if type(value) == "table" then
      for _, v in ipairs(value) do
        vim.opt[name]:append(v)
      end
    else
      vim.opt[name]:append(value)
    end
    print_ok(name)
  end
end

local function set_option(name, value)
  if name == "append" then
    append_options(value)
    return
  end

  local opt_type = get_option_type(name)

  if opt_type == "table" then
    if type(value) == "table" then
      vim.opt[name] = value
      print_ok(name)
    elseif type(value) ~= "table" then
      notify(name, value)
    end
  else
    vim.opt[name] = value
    print_ok(name)
  end
end

local function set_opitons()
  local filetypes = {}
  local normal = {}

  for key, options in pairs(OPTIONS) do
    if key == "normal" then
      normal = options
    else
      table.insert(filetypes, key)
    end
  end

  for name, value in pairs(normal) do
    local ok = pcall(set_option, name, value)
  end

  if #filetypes == 0 then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      for name, value in pairs(OPTIONS[ft]) do
        local ok = pcall(set_option, name, value)
      end
    end,
  })
end

--- @param opts NeovimOptionsSetupParam
function M.setup(opts)
  for _, path in ipairs(opts.paths) do
    local module_path = path:gsub("%.lua$", "")
    local success, source = pcall(require, module_path)

    if success and type(source) == "table" then
      iter_filetype(source)
    end
  end
  set_opitons()
end

return M
