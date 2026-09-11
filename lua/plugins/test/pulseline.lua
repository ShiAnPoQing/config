return {
  name = "pulseline.nvim",
  config = function()
    local pulseline = require("pulseline")
    -- pulseline.setup({
    --   statusline = pulseline.Statusline(function(self)
    --     self.useState({ state = true })
    --     self:on("ModeChanged", function()
    --       self.state.set("true")
    --     end)
    --     self:Component(function(c) end,  {self.stata})
    --     self:Fragment(function(c)
    --     end)
    --   end),
    -- })
  end,
}
