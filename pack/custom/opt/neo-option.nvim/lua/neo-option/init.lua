local M = {}

--- @class NeoOptionOptions

local function set_option(name, value, opt_table)
  if type(value) == "function" then
    value({
      append = function(v)
        local ok = pcall(opt_table[name].append, opt_table[name], v)
        if not ok then
          vim.notify("Option: " .. name .. " append error")
        end
      end,
      prepend = function(v)
        local ok = pcall(opt_table[name].prepend, opt_table[name], v)
        if not ok then
          vim.notify("Option: " .. name .. " prepend error")
        end
      end,
      remove = function(v)
        local ok = pcall(opt_table[name].remove, opt_table[name], v)
        if not ok then
          vim.notify("Option: " .. name .. " remove error")
        end
      end,
      get = function(v)
        local ok = pcall(opt_table[name].get, opt_table[name], v)
        if not ok then
          vim.notify("Option: " .. name .. " get error")
        end
      end,
    })
    return
  end
  local ok = pcall(function()
    opt_table[name] = value
  end)
  if not ok then
    print(name)
  end
end

function M.setup(options)
  options = options or {}
  if type(options) ~= "table" then
    options = {}
  end

  for name, value in pairs(options) do
    set_option(name, value, vim.opt)
  end
end

function M.setlocal(options)
  options = options or {}
  if type(options) ~= "table" then
    options = {}
  end

  for name, value in pairs(options) do
    set_option(name, value, vim.opt_local)
  end
end

---- 1. 全局
---- 2. 局部
---- 3. 光标窗口

-- local GLOBAL_OPTION_MAP = {
--   writedelay = true,
--   writebackup = true,
--   writeany = true,
--   write = true,
--   wrapscan = true,
--   winwidth = true,
-- }

function M.toggle_global(name, values)
  for _, value in ipairs(values) do
    vim.opt[name] = value
  end
end

return M

--[[
	      Command		       global value	   local value	       condition ~
      :set option=value	     set	          set
 :setlocal option=value	      -		          set
:setglobal option=value	     set	           -
      :set option?	          -		        display	    local value is set
      :set option?	       display	         -	      local value is not set
 :setlocal option?	          -		        display
:setglobal option?	       display	         -
--]]
