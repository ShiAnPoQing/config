--- @class my.profile
--- @field pro my.profile.pro
--- @field promax my.profile.promax
local M = vim._defer_require("my.profile", {
  pro = ..., --- @module "my.profile.pro"
  promax = ..., --- @module "my.profile.promax"
})

local current_profile

--- @param value 'pro'|'promax'
function M.set(value)
  vim.validate("value", value, "string")
  if current_profile then
    M[current_profile]._runtime.cleanup()
  end
  current_profile = value
  M[value]._runtime.init()
end

return M
