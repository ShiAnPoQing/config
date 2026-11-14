--- @class my.atom._menu.Opts.Layout.Column
--- @field gap? integer
--- @field [integer] string

--- @class my.atom._menu.Opts.Layout.Width
--- @field min? integer
--- @field max? integer

--- @class my.atom._menu.Opts.Layout.Component
--- @field width? my.atom._menu.Opts.Layout.Width
--- @field align? 'left'|'center'|'right'
--- @field ellipsis? string
--- @field text? [string, string][]|fun(ctx):[string, string][]

--- @class my.atom._menu.Opts.Layout.Columns
--- @field gap? integer
--- @field [integer] my.atom._menu.Opts.Layout.Column

--- @class my.atom._menu.Opts.Layout
--- @field columns? my.atom._menu.Opts.Layout.Columns
--- @field components? table<string, my.atom._menu.Opts.Layout.Component>
--- @field padding? integer | [integer, integer]

--- @alias my.atom._menu.Size {max?:integer, min?:integer}|integer

--- @class my.atom._menu.Opts.Window
--- @field height? integer

--- @class my.atom._menu.Opts
--- @field layout? my.atom._menu.Opts.Layout
--- @field window? my.atom._menu.Opts.Window
