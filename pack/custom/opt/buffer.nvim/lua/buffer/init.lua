local M = {}

---@class BufferWinConfig
---@field position? "above" | "below" | "left" | "right" | "float"
---@field width? integer
---@field height? integer

---@class BufferConfig
---@field win? BufferWinConfig

---@type BufferConfig
local default_config = {
  win = {
    position = "float",
    width = math.floor(vim.o.columns * 0.5),
    height = math.floor((vim.o.lines - vim.o.cmdheight) * 0.3),
  },
}

---@param config? BufferConfig
function M.setup(config)
  require("buffer.core").init(vim.tbl_deep_extend("force", default_config, config or {}))
end

function M.buffer()
  require("buffer.core").buffer()
end

return M
