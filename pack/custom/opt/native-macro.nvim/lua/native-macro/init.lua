--[[
EXAMPLE 1: `last()`: do something in normal mode then start insert mode
    1. `last()` always produce a sequence of atoms:
        Feed insert key(`a`) always start an `insert session`, until you leave insert mode.
        This always produce a CmdAtom, like `1aHellowWord\27`.

        Therefore, `last()` cannot produce a complete CmdAtom.
        Therefore, `last()` can only produce a series of atoms.

        if you want to fully repeat `last()`, 
        You must repeat all the atoms of `last()`.

        Therefore, `last()` must not be an atom. `last()` is merely a wrapper.
        Therefore, you can't map `<cmd>lua last()<cr>`
                   you need to map:  
                     vim.keymap.set("n", "<F6>", function()
                        _G.last()
                     end)

    2. `last()` = {atom} + {insert atom}  

_G.last = function()
  if is_blank_line() and not my.multicursor.active() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.v.count1 .. "A<C-f>", true, false, true), "n", false)
    return
  end

  my.multicursor.transform(0, function(_, extmark)
    local line = vim.api.nvim_buf_get_lines(0, extmark[1], extmark[1] + 1, true)[1]
    return { extmark[1], #line }
  end)
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
  vim.api.nvim_feedkeys(vim.v.count1 .. "a", "nt", false)
end
vim.keymap.set("n", "<F6>", "<cmd>lua last()<cr>")

--]]

local M = {}

function M.setup()
  require("native-macro._record").init()
  require("native-macro._repeat").init()
end

-- {0-9a-z".=*+}
function M._repeat()
  ---@diagnostic disable-next-line: param-type-mismatch
  local char = vim.fn.nr2char(vim.fn.getchar())
  require("native-macro._repeat"):_repeat(char)
end

return M
