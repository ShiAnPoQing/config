local M = {}

--- @alias Ring.Range [ [integer, integer], [integer, integer] ]
--- @alias Ring.Pair [string|fun():string, string|fun():string]

--- @class Ring.Register
--- @field [1] string|fun():Ring.Range|nil
--- @field [2] Ring.Pair

--- @class Ring.Config
--- @field registers table<string, Ring.Register>

--- @param config? Ring.Config
function M.setup(config)
  config = config or { registers = {} }
  require("ring.core").register(config.registers)
end

return M
