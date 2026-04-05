local ModeComponent = {
  init = function(self)
    self.mode_name = vim.fn.mode(1)
    self.mode = self:compute()
  end,
  provider = function(self)
    return self.mode
  end,
  update = function(self)
    self.mode = self:compute()
  end,
  hl = function(self)
    return self.mode_hls[self.mode_name]
  end,
  event = {
    "ModeChanged",
    callback = function(self)
      self.mode_name = vim.fn.mode(1)
      self:redraw()
    end,
  },
  compute = function(self)
    local mode_status = self.mode_names[self.mode_name]
    return " " .. mode_status .. " "
  end,
  mode_hls = {
    n = "NORMAL",
    no = "O-PENDING",
    nov = "O-PENDING(VISUAL)",
    noV = "O-PENDING(V-LINE)",
    ["no\22"] = "O-PENDING(V-BLOCK)",
    niI = "NORMAL(INSERT)",
    niR = "NORMAL(REPLACE)",
    niV = "NORMAL(V-REPLACE)",
    nt = "NORMAL(TERMINAL)",
    ntT = "NORMAL(TERMINAL)",

    v = "VISUAL",
    vs = "VISUAL(SELECT)",
    V = "V-LINE",
    Vs = "V-LINE(SELECT)",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK(SELECT)",

    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",

    i = "INSERT",
    ic = "INSERT(COMPLETION)",
    ix = "INSERT(COMPLETION)",

    R = "REPLACE",
    Rc = "REPLACE(COMPLETION)",
    Rx = "REPLACE(COMPLETION)",
    Rv = "V-REPLACE",
    Rvc = "V-REPLACE(COMPLETION)",
    Rvx = "REPLACE(COMPLETION)",

    c = "COMMAND",
    cr = "COMMAND(REPLACE)",
    cv = "Ex",
    cvr = "Ex(INSERT)",

    r = "PROMPT",
    rm = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    t = "TERMINAL",
  },
  mode_names = {
    n = "NORMAL",
    no = "O-PENDING",
    nov = "O-PENDING(VISUAL)",
    noV = "O-PENDING(V-LINE)",
    ["no\22"] = "O-PENDING(V-BLOCK)",
    niI = "NORMAL(INSERT)",
    niR = "NORMAL(REPLACE)",
    niV = "NORMAL(V-REPLACE)",
    nt = "NORMAL(TERMINAL)",
    ntT = "NORMAL(TERMINAL)",

    v = "VISUAL",
    vs = "VISUAL(SELECT)",
    V = "V-LINE",
    Vs = "V-LINE(SELECT)",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK(SELECT)",

    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",

    i = "INSERT",
    ic = "INSERT(COMPLETION)",
    ix = "INSERT(COMPLETION)",

    R = "REPLACE",
    Rc = "REPLACE(COMPLETION)",
    Rx = "REPLACE(COMPLETION)",
    Rv = "V-REPLACE",
    Rvc = "V-REPLACE(COMPLETION)",
    Rvx = "REPLACE(COMPLETION)",

    c = "COMMAND",
    cr = "COMMAND(REPLACE)",
    cv = "Ex",
    cvr = "Ex(INSERT)",

    r = "PROMPT",
    rm = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    t = "TERMINAL",
  },
}

local File = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  provider = function(self)
    return self.file
  end,
  update = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      filename = "[No Name]"
    end
    if #filename > math.floor(vim.o.columns * 0.5) then
      filename = vim.fn.pathshorten(filename)
    end
    self.file = filename
  end,
  event = {
    {
      "VimResized",
      callback = function(self)
        self.redraw()
      end,
    },
    {
      { "BufWinEnter", "DirChanged", "WinEnter" },
      callback = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        self.redraw()
      end,
    },
  },
}

local Diagnostic = {
  error_icon = " ",
  warn_icon = " ",
  info_icon = " ",
  hint_icon = " ",
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  event = {
    "DiagnosticChanged",
    "BufEnter",
  },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = "DiagnosticError",
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = "DiagnosticWarn",
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = "DiagnosticInfo",
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = "DiagnosticHint",
  },
}

return {
  name = "plain-statusline.nvim",
  config = function()
    require("plain-statusline").setup({
      ModeComponent,
      Diagnostic,
      File,
    })
  end,
}
