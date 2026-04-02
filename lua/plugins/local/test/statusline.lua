local ModeComponent = {
  mode_hls = {
    n = "DiagnosticInfo",
    no = "DiagnosticInfo",
    nov = "DiagnosticInfo",
    noV = "DiagnosticInfo",
    niI = "DiagnosticInfo",
    niR = "DiagnosticInfo",
    niV = "DiagnosticInfo",
    nt = "DiagnosticInfo",
    v = "DiagnosticWarn",
    vs = "DiagnosticWarn",
    V = "DiagnosticWarn",
    Vs = "DiagnosticWarn",
    s = "Select",
    S = "Select",
    ["\19"] = "Select",
    i = "Insert",
    ic = "Insert",
    ix = "Insert",
    R = "Replace",
    Rc = "Replace",
    Rx = "Replace",
    Rv = "Replace",
    Rvc = "Replace",
    Rvx = "Replace",
    c = "Command",
    cv = "Command",
    r = "Command",
    rm = "Command",
    ["r?"] = "Command",
    ["!"] = "Command",
    t = "Terminal",
  },
  mode_names = {
    -- Normal
    n = "Normal",
    no = "Operator",
    nov = "Operator",
    noV = "Operator",
    ["no\22"] = "Operator",

    -- Normal (insert-like)
    niI = "Normal(Insert)",
    niR = "Normal(Replace)",
    niV = "Normal(Virtual Replace)",
    nt = "Normal(Terminal)",

    -- Visual
    v = "Visual",
    vs = "Visual(Select)",
    V = "Visual Line",
    Vs = "Visual Line(Select)",
    ["\22"] = "Visual Block",
    ["\22s"] = "Visual Block(Select)",

    -- Select mode
    s = "Select",
    S = "Select Line",
    ["\19"] = "Select Block",

    -- Insert
    i = "Insert",
    ic = "Insert(Completion)",
    ix = "Insert(Completion)",

    -- Replace
    R = "Replace",
    Rc = "Replace(Completion)",
    Rx = "Replace(Completion)",
    Rv = "Virtual Replace",
    Rvc = "Virtual Replace(Completion)",
    Rvx = "Virtual Replace(Completion)",

    -- Command
    c = "Command",
    cv = "Ex",

    -- Prompt / misc
    r = "Prompt",
    rm = "More",
    ["r?"] = "Confirm",

    ["!"] = "Shell",
    t = "Terminal",
  },
  provider = function(self)
    self.mode = vim.fn.mode(1)
    return self.mode_names[self.mode]
  end,
  hl = function(self)
    return self.mode_hls[self.mode]
  end,
  update = "ModeChanged",
}

local File = {
  init = function(self)
    self.file = vim.fn.expand("%:p")
  end,
  provider = function(self)
    return self.file or "%f"
  end,
  update = {
    "VimResized",
    callback = function(self)
      local width = vim.o.columns
      local file = vim.fn.expand("%:p")
      if #file > math.floor(width * 0.5) then
        self.file = vim.fn.pathshorten(file)
      else
        self.file = file
      end
      self.ensure_update()
    end,
  },
}

return {
  name = "plain-statusline.nvim",
  config = function()
    require("plain-statusline").setup({
      ModeComponent,
      File,
    })
  end,
}
