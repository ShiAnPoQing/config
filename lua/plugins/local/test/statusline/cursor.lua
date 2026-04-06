local S = require("plugins.local.test.statusline.shared")
local colors = S.colors

return {
  hl = function(self)
    return self:get_current_mode_hl()
  end,
  {
    provider = "",
    hl = function(self)
      local mode_hl = self:get_current_mode_hl()
      if type(mode_hl) == "table" then
        return vim.tbl_extend("force", mode_hl, { reverse = true, fg = colors.bg3 })
      end
    end,
  },
  {
    provider = " %l:%c ",
  },
}
