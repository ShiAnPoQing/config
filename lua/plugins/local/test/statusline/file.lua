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
    condition = function(self)
      local buf = self.shared.buf
      return buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified
    end,
    provider = " ",
    hl = { fg = colors.yellow_green },
  },
  {
    condition = function(self)
      local buf = self.shared.buf
      return buf and vim.api.nvim_buf_is_valid(buf) and (not vim.bo[buf].modifiable or vim.bo[buf].readonly)
    end,
    provider = " 󰈡 ",
    hl = { fg = colors.red },
  },
}

local FileName = {
  provider = function(self)
    return self.file
  end,
  hl = function(self)
    local buf = self.shared.buf
    if buf and vim.api.nvim_buf_is_valid(buf) then
      return vim.bo[buf].modified and { fg = colors.yellow_green }
    end
  end,
}

return {
  shared = {},
  init = function(self)
    self:update_filename()
  end,
  update_filename = function(self)
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    self.shared.buf = buf
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].filetype == "help" then
      name = vim.fn.fnamemodify(name, ":t")
    end
    self.shared.filename = name
  end,
  update = function(self, targets)
    for _, target in ipairs(targets) do
      if target.event == "BufWinEnter" then
        self:update_filename()
      elseif target.event == "DirChanged" then
        self:update_filename()
      elseif target.event == "WinEnter" then
        self:update_filename()
      end
      local filename = self.shared.filename
      if filename == "" then
        filename = "[No Name]"
      end
      if #filename > math.floor(vim.o.columns * 0.4) then
        filename = vim.fn.pathshorten(filename)
      end
      self.file = filename
    end
  end,
  event = {
    VimResized = function() end,
    BufWinEnter = function() end,
    DirChanged = function() end,
    WinEnter = function() end,
  },
  FileIcon,
  FileName,
  FileFlags,
}
