local M = {}

function M.setup(opts)
  vim.keymap.set({ "n", "x" }, ".", function()
    require("repeat.core"):operation()
  end, {
    desc = "Repeat operation",
  })
  vim.keymap.set({ "n", "x" }, ",", function()
    require("repeat.core"):motion()
  end, {
    desc = "Repeat motion",
  })
end

--- @param spec RepeatSpec
function M.set(spec) end

--- @param callback fun()
function M.set_operation(callback)
  require("repeat.core"):set_operation(callback)
end

--- @param callback fun()
function M.set_motion(callback)
  require("repeat.core"):set_motion(callback)
end

return M
