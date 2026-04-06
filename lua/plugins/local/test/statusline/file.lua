local S = require("plugins.local.test.statusline.shared")
local colors = S.colors

local FileIcon = {
  provider = function(self)
    local extension = vim.fn.fnamemodify(self.shared.filename, ":e")
    self.icon, self.icon_color =
      require("nvim-web-devicons").get_icon_color(self.shared.filename, extension, { default = true })
    return self.icon and self.icon .. " " or " "
  end,
  hl = function(self)
    return { fg = self.icon_color or "NONE" }
  end,
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " [+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = " ",
    hl = { fg = "orange" },
  },
}

local FileName = {
  provider = function(self)
    return self.file
  end,
  init = function(self)
    self:update_filename()
  end,
  update_filename = function(self)
    self.shared.filename = vim.api.nvim_buf_get_name(0)
    self.buf = vim.api.nvim_get_current_buf()
  end,
  update = function(self)
    local filename = vim.fn.fnamemodify(self.shared.filename, ":.")
    if filename == "" then
      filename = "[No Name]"
    end
    if #filename > math.floor(vim.o.columns * 0.4) then
      filename = vim.fn.pathshorten(filename)
    end
    self.file = filename
  end,
  event = {
    VimResized = function(self)
      self:update()
    end,
    BufWinEnter = function(self)
      local filetype = vim.bo.filetype
      if
        filetype == "blink-cmp-menu"
        or filetype == "blink-cmp-documentation"
        or (filetype == "" and not vim.bo.modifiable)
      then
        return
      end
      self:update_filename()
      self:update()
    end,
    DirChanged = function(self)
      self:update_filename()
      self:update()
    end,
    WinEnter = function(self)
      self:update_filename()
      self:update()
    end,
  },
  hl = function(self)
    if self.buf then
      local modified = vim.api.nvim_get_option_value("modified", {
        scope = "local",
        buf = self.buf,
      })
      return modified and {
        fg = colors.yellow_green,
      }
    end
  end,
}

return {
  shared = {},
  FileIcon,
  FileName,
  FileFlags,
}
