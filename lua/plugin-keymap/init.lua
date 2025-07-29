-- [lhs] = {rhs, mode, opts},
-- [lhs] = {rhs, {mode1, mode2}, opts},
-- [lhs] = {rhs, {mode1, {mode2, opts}}, opts}
-- [lhs] = {rhs,
--                {
--                  mode1,
--                  {
--                    mode2,
--                    opts
--                  },
--                  {
--                    {mode3, mode4},
--                    opts
--                  }
--                },
--                opts
--                }
-- [lhs] = { {rhs, mode, opts},
--    {rhs, mode, opts}
-- }
-- 6,7,8,9.. same as 1, 2, 3, 4

local M = {}

local filetype_set_keymaps = {
  typescript = {},
  javascript = {},
  lua = {},
  typescriptreact = {},
}

--- @alias ModeType string|table

--- @class KeymapConfig
--- @field mode string|table
--- @field lhs string
--- @field rhs string|function
--- @field opts? table

--- @class KeymapConfigShare
--- @field lhs string
--- @field rhs string|function
--- @field opts table

--- @param value string|table
--- @return boolean
local function isMoreRhs(value)
  if type(value) == "table" then
    return true
  end

  return false
end

--- @param keymap KeymapConfig
local function setKeymap(keymap)
  local ok, v = pcall(function(mode, lhs, rhs, opts)
    if opts.filetype ~= nil then
      if filetype_set_keymaps[opts.filetype] then
        table.insert(filetype_set_keymaps[opts.filetype], function(buffer)
          opts.filetype = nil
          opts.buffer = buffer
          vim.keymap.set(mode, lhs, rhs, opts)
        end)
        return
      end
    end

    vim.keymap.set(mode, lhs, rhs, opts)
  end, keymap.mode, keymap.lhs, keymap.rhs, keymap.opts)

  if not ok then
    vim.notify("keymap 格式设置有误！" .. keymap.lhs, vim.log.levels.ERROR)
  end
end

--- @param mode ModeType
--- @param keymap KeymapConfigShare
--- @return boolean
local function hadKeymapSet(mode, keymap)
  if type(mode) == "string" then
    setKeymap({
      mode = mode,
      lhs = keymap.lhs,
      rhs = keymap.rhs,
      opts = keymap.opts,
    })
    return true
  end

  return false
end

--- @param modeObj {[1]: ModeType, [2]?: table} 格式为 [mode, opts]
--- @param keymap KeymapConfigShare
--- @param parseModes function
local function parseModeObj(modeObj, keymap, parseModes)
  local mode = modeObj[1]
  keymap.opts = vim.tbl_extend("keep", modeObj[2] or {}, keymap.opts)

  if not hadKeymapSet(mode, keymap) then
    parseModes(mode, keymap)
  end
end

--- @param modes table
--- @param keymap KeymapConfigShare
local function parseModes(modes, keymap)
  for _, mode in ipairs(modes) do
    if not hadKeymapSet(mode, keymap) then
      parseModeObj(mode, keymap, parseModes)
    end
  end
end

--- @param mode ModeType
--- @param keymap KeymapConfigShare
local function addOneRhsKeymap(mode, keymap)
  if not hadKeymapSet(mode, keymap) then
    parseModes(mode, keymap)
  end
end

--- @param lhs string
--- @param more table<integer, table>
local function addMoreRhsKeymap(lhs, more)
  for _, one in pairs(more) do
    addOneRhsKeymap(one[2], { lhs = lhs, rhs = one[1], opts = one[3] or {} })
  end
end

--- @param maps table<string, table>
function M.add(maps)
  for lhs, value in pairs(maps) do
    local rhs = value[1]
    local mode = value[2]
    local opts = value[3] or {}

    if isMoreRhs(rhs) then
      addMoreRhsKeymap(lhs, value)
    else
      addOneRhsKeymap(mode, { lhs = lhs, rhs = rhs, opts = opts })
    end
  end
end

function M.del(maps) end

local function load_keymaps(base_path, current_path)
  local path = current_path .. "/*.lua"
  local files = vim.fn.glob(path, true, true)

  for _, file in ipairs(files) do
    local module_path = file:gsub(base_path, ""):gsub("%.lua$", "")
    local success, source = pcall(require, module_path)
    if success and type(source) == "table" then
      M.add(source)
    end
  end

  local dirs = vim.fn.glob(current_path .. "/*", true, true)
  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      load_keymaps(base_path, dir)
    end
  end
end

local function load_filetype_keymaps()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "lua", "typescriptreact" },
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if filetype_set_keymaps[ft] ~= nil then
        for _, setkeymap in ipairs(filetype_set_keymaps[ft]) do
          setkeymap(args.buf)
        end
      end
    end,
  })
end

function M.setup()
  local base_path = vim.fn.stdpath("config") .. "/lua/"
  local path = base_path .. "keymaps"
  load_keymaps(base_path, path)
  load_filetype_keymaps()
  return M
end

return M

-- nvim_set_keymap({mode}, {lhs}, {rhs}, {opts})
-- @param mode  string 空字符串（:map）、“n”、“i”、“v”、“x”、 “！”（:map!）、“ia”、“ca”或“!a”分别表示插入模式、命令行模式或两者下的缩写
-- @param lhs   string 映射的左侧
-- @param rhs   string 映射的右侧
-- @param opts  table? :

--      "nowait"    boolean default false @是否等待按键组合
--      "silent"    boolean default false @不会在命令行上回显
--      "script"    boolean default false @用于定义新的映射或缩写，则映射将仅使用在{rhs}脚本本地定义的映射重新映射字符，以“<SID>”开头。这可用于避免脚本外部的映射干扰
--      "expr"      boolean defualt false @参数是一个表达式需要求值：可以执行命令或函数
--      "unique"    boolean default false @如果该映射或缩写已经存在，则该命令将失败

--      "noremap"   boolean default false @类似于 :noremap 映射本意
--      "desc"      string                @描述
--      "callback"  fun                   @代替 {rhs} 调用的 Lua 函数。
--      "replace_keycodes" boolean        @当“expr”为真时，替换结果字符串中的键码
--                                        从 Lua“回调”返回 nil 相当于返回一个空字符串。

-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})
-- @param mode string|string[]          @参见 nvim_set_keymap()
-- @param lhs string                    @映射的左侧
-- @param rhs string|function           @映射的右侧，可以是 Lua 函数。
-- @param opts table?                   @与 nvim_set_keymap() 相同
--    {buffer} integer|boolean 创建缓冲区本地映射，当前缓冲区为 0 或真。
--    {remap} boolean，默认值：false 使映射递归。与 {noremap} 相反。
--    !!注意!!：如果“expr”为真，则 {replace_keycodes} 默认为真

-- vim.keymap.set 更强大 可以直接映射lua函数

-- vim.api.nvim_set_keymap("n", "<F3>", "", {
--   callback = function(a)
--     print("行")
--   end
-- })

-- vim.keymap.set("n", "<F3>", function()
--   print("行")
-- end, {})
