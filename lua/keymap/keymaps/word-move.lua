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

-- /\%(\%(\k\)\@!.\)\+

local zq_maps = {
  ["i"] = { "o", "w" },
  ["o"] = { "o", "e" },
}

return {
  -- :h zq
  -- Not supported:
  -- - Text objects
  -- - Lua, |<Cmd>| or ":" mappings (except |:map-<expr>|).
  -- Issue:
  --    If some o mode motion keymap is not expr=true, zq{motion} will be failed
  -- Solution:
  --    remap `zq`: when typed zq, reset o mode motion keymap as expr=true
  ["zq"] = {
    function()
      local maps = {}
      for key, map in pairs(zq_maps) do
        table.insert(maps, vim.fn.maparg(key, "o", false, true))
        vim.keymap.set(map[1], key, map[2], map[3] or {})
      end
      vim.api.nvim_create_autocmd("CmdAtom", {
        callback = function(ev)
          if ev.data.operator == "zq" then
            for _, map in ipairs(maps) do
              vim.fn.mapset(map)
            end
          end
          return true
        end,
      })
      return "zq"
    end,
    { "n", "x" },
    expr = true,
  },

  ["<M-i>"] = {
    "bi",
    "n",
    desc = "Backward to the start of word[count] and start insert mode",
  },
  ["<M-o>"] = {
    "ea",
    "n",
    desc = "Forword to the end of the word[count] and start insert mode",
  },
  ["<M-S-i>"] = {
    "Bi",
    "n",
    desc = "Backward to the start of WORD and start insert mode",
  },
  ["<M-S-o>"] = {
    "Ea",
    "n",
    desc = "Forword to the end of the WORD and start insert mode",
  },
}
