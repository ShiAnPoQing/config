--- @class my._atom._menu.Opts.Layout.Column
--- @field gap? integer
--- @field [integer] string

--- @class my._atom._menu.Opts.Layout.Width
--- @field min? integer
--- @field max? integer

--- @class my._atom._menu.Opts.Layout.Component
--- @field width? my._atom._menu.Opts.Layout.Width
--- @field align? 'left'|'center'|'right'
--- @field ellipsis? string
--- @field text? string | fun(ctx: any):string
--- @field highlight? string | fun(ctx: any):string

--- @class my._atom._menu.Opts.Layout
--- @field columns? my._atom._menu.Opts.Layout.Column[]
--- @field components? table<string, my._atom._menu.Opts.Layout.Component>
--- @field padding? integer | [integer, integer]

--- @alias my._atom._menu.Size {max?:integer, min?:integer}|integer

--- @class my._atom._menu.Opts.Window
--- @field height? integer

--- @class my._atom._menu.Opts
--- @field layout? my._atom._menu.Opts.Layout
--- @field window? my._atom._menu.Opts.Window
