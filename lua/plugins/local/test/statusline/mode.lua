local S = require("plugins.local.test.statusline.shared")
local colors = S.colors

local function compute(self)
  local mode_status = self.mode_names[self.shared.mode_name]
  return " " .. mode_status .. " "
end

local function update(self)
  self.shared.mode_name = vim.fn.mode(1)
  self.mode = self:compute()
end

local Arrow = {
  provider = "",
  hl = function(self)
    local current_mode_hl = self:get_current_mode_hl()
    return vim.tbl_extend("force", current_mode_hl, { reverse = true, fg = colors.bg4 })
  end,
}

return {
  compute = compute,
  init = function(self)
    update(self)
  end,
  provider = function(self)
    return self.mode
  end,
  hl = function(self)
    return self:get_current_mode_hl()
  end,
  event = { ModeChanged = update },
  Arrow,
}
