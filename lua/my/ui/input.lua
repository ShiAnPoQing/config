--- @class my.ui.Input.Opts
--- @field prompt? string
--- @field placeholder? string
--- @field on_submit? fun(value: string)
--- @field on_change? fun(value: string)
--- @field on_close? fun()

--- @class my.ui.Input: my.Instance<my.ui.Window>, my.ui.Window
--- @field test integer
local Input = my.ui.Window:extend("my.ui.Input")

--- @param window_opts my.ui.Window.Opts
--- @param input_opts my.ui.Input.Opts
function Input:init(window_opts, input_opts)
  self.super(window_opts)
end

--- @class my.ui.Class.Input: my.ui.Class.Window
--- @overload fun(window_opts: my.ui.Window.Opts, input_opts: my.ui.Input.Opts): my.ui.Input

return Input --[[@as my.ui.Class.Input]]
