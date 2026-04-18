local S = require("plugins.local.test.statusline.shared")
local colors = S.colors

local function compute(self)
  return " " .. self.mode_names[self.shared.mode_name] .. " "
end

local Arrow = {
  provider = "",
  hl = function(self)
    return vim.tbl_extend(
      "force",
      self:get_current_mode_hl(),
      { reverse = true, fg = vim.b.gitsigns_status_dict and colors.bg4 or colors.bg3 }
    )
  end,
}

return {
  compute = compute,
  provider = function(self)
    return self.mode
  end,
  init = function(self)
    self.shared.mode_name = vim.fn.mode(1)
    self.mode = self:compute()
  end,
  update = function(self, events)
    for _, event in ipairs(events) do
      if event.event == "ModeChanged" then
        self.mode = self:compute()
      end
    end
  end,
  event = {
    ModeChanged = function(self)
      self.shared.mode_name = vim.fn.mode(1)
    end,
  },
  hl = function(self)
    return self:get_current_mode_hl()
  end,
  Arrow,
}
