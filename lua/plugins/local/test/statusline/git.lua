local S = require("plugins.local.test.statusline.shared")
local colors = S.colors

return {
  event = {
    StatusRedrawPre = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      if self.status_dict then
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end
    end,
  },
  hl = function(self)
    local current_mode_hl = self:get_current_mode_hl()
    return {
      fg = current_mode_hl and current_mode_hl.bg or colors.purple,
      bg = colors.bg4,
    }
  end,
  {
    condition = function(self)
      return self.status_dict
    end,
    {
      provider = function(self)
        return self.status_dict and "  " .. self.status_dict.head .. " "
      end,
    },
    {
      provider = function(self)
        local count = 0
        if self.status_dict then
          count = self.status_dict.added or 0
        end
        return count > 0 and "+" .. count .. " "
      end,
      hl = {
        fg = colors.yellow_green,
        bg = colors.bg4,
      },
    },
    {
      provider = function(self)
        local count = 0
        if self.status_dict then
          count = self.status_dict.removed or 0
        end
        return count > 0 and "-" .. count .. " "
      end,
      hl = {
        fg = colors.red,
        bg = colors.bg4,
      },
    },
    {
      provider = function(self)
        local count = 0
        if self.status_dict then
          count = self.status_dict.removed or 0
        end
        return count > 0 and "~" .. count
      end,
      hl = {
        fg = colors.purple,
        bg = colors.bg4,
      },
    },
    {
      provider = "",
      hl = {
        fg = colors.bg4,
      },
    },
    {
      provider = "%<",
    },
  },
}
