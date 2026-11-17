--- @class my.ui.Input.Opts
--- @field prompt? string
--- @field placeholder? string
--- @field on_submit? fun(value: string)
--- @field on_change? fun(value: string)
--- @field on_close? fun()

--- @class my.ui.Input: my.Instance<my.ui.Input, my.ui.Window>
--- @field test integer

--- @class my.ui.Class.Input: my.Class<my.ui.Class.Input>
--- @overload fun(window_opts: my.ui.Window.Opts, input_opts: my.ui.Input.Opts): my.ui.Input
local Input = my.class(my.ui.Window)

--- @param self my.ui.Input
--- @param window_opts my.ui.Window.Opts
--- @param input_opts my.ui.Input.Opts
function Input.init(self, window_opts, input_opts)
  self.super(window_opts)
end

return Input
