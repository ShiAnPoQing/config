--- @class my.ui
--- @field util my.ui.util
--- @field Box my.ui.Class.Box
--- @field Box fun(boxs: (my.ui.Window|my.ui.Box)[], opts: my.ui.Box.Opts): my.ui.Box
--- @field Window my.ui.Class.Window
--- @field Window fun(opts: my.ui.Window.Opts): my.ui.Window
--- @field Input my.ui.Class.Input
--- @field Input fun(window_opts: my.ui.Window.Opts, input_opts: my.ui.Input.Opts): my.ui.Input
--- @field _Container my.ui.Class.Container
--- @field _Container fun(name: my.ui.Container.Name): my.ui.Container
--- @field editor my.ui.Container
--- @field tabline my.ui.Container
--- @field laststatus my.ui.Container
--- @field mouse my.ui.Container
local M = my.util.defer_require("my.ui", {
  Window = "window",
  Input = "input",
  Box = "box",
  _Container = "container",
  editor = function(mod)
    mod = mod --[[@as my.ui]]
    return mod._Container("editor")
  end,
  laststatus = function(mod)
    mod = mod --[[@as my.ui]]
    return mod._Container("laststatus")
  end,
  tabline = function(mod)
    mod = mod --[[@as my.ui]]
    return mod._Container("tabline")
  end,
  mouse = function(mod)
    mod = mod --[[@as my.ui]]
    return mod._Container("mouse")
  end,
  util = true,
})

return M
