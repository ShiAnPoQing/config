local function update(self)
  self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
end

return {
  error_icon = " ",
  warn_icon = " ",
  info_icon = " ",
  hint_icon = " ",
  init = function(self)
    update(self)
  end,
  update = function(self, events)
    for _, event in ipairs(events) do
      if event.event == "DiagnosticChanged" or event.event == "BufEnter" then
        update(self)
      end
    end
  end,
  event = {
    DiagnosticChanged = function() end,
    BufEnter = function() end,
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
      return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
    end,
    hl = "DiagnosticHint",
  },
}
