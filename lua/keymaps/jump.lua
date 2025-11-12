---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

return {
  ["<C-i>"] = {
    function()
      require("builtin.jump-list").jump(-1)
    end,
    "n",
    desc = "Go to [count] older cursor position in jump list",
  },
  ["<C-o>"] = {
    function()
      require("builtin.jump-list").jump(1)
    end,
    "n",
    desc = "Go to [count] newer cursor position in jump list",
  },
  ["g<C-i>"] = {
    function()
      local function callback()
        require("builtin.jump-list").switch_lock(-1)
        require("repeat").set_operation(callback)
      end
      callback()
    end,
    "n",
    desc = "Go to [count] older cursor position in jump list[switch buffer lock]",
  },
  ["g<C-o>"] = {
    function()
      local function callback()
        require("builtin.jump-list").switch_lock(1)
        require("repeat").set_operation(callback)
      end
      callback()
    end,
    "n",
    desc = "Go to [count] newer cursor position in jump list[switch buffer lock]",
  },
  ["<C-S-i>"] = {
    function()
      local function callback()
        require("builtin.jump-list").jump_buffer(-1)
        require("repeat").set_operation(callback)
      end
      callback()
    end,
    "n",
    desc = "Go to [count] older cursor position in jump list[buffer]",
  },
  ["<C-S-o>"] = {
    function()
      local function callback()
        require("builtin.jump-list").jump_buffer(1)
        require("repeat").set_operation(callback)
      end
      callback()
    end,
    "n",
    desc = "Go to [count] newer cursor position in jump list[buffer]",
  },
}
