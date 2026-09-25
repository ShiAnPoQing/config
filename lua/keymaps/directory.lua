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
  ["<leader>cd"] = { "<cmd>" .. my.command.constants.Cd .. "<CR>", "n", desc = "Change directory to file(Global)" },
  ["<leader>tcd"] = {
    "<cmd>" .. my.command.constants.Tcd .. "<CR>",
    "n",
    desc = "Change directory to file(Current Tabpage)",
  },
  ["<leader>lcd"] = {
    "<cmd>" .. my.command.constants.Lcd .. "<CR>",
    "n",
    desc = "Change directory to file(Current Window)",
  },
  ["<leader>bcd"] = {
    "<cmd>" .. my.command.constants.Bcd .. "<CR>",
    "n",
    desc = "Change directory to file(Current Buffer)",
  },
}

--[[
  将当前文件所在目录设置为工作目录： cd %:h
--]]
