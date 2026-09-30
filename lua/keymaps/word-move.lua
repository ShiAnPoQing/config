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
  ["i"] = { "<cmd>lua my.motion.backward_word_start()<cr>", { "n", "x", "o" }, desc = "[count] backward word start" },
  ["o"] = { "<cmd>lua my.motion.forward_word_end()<cr>", { "n", "x", "o" }, desc = "[count] forward word end" },
  ["I"] = { "<cmd>lua my.motion.backward_WORD_start()<cr>", { "n", "x", "o" }, desc = "[count] backward WORD start" },
  ["O"] = { "<cmd>lua my.motion.forward_WORD_end()<cr>", { "n", "x", "o" }, desc = "[count] forward WORD end" },
  ["<space>i"] = { "<cmd>lua my.motion.backward_word_end()<cr>", { "n", "x", "o" }, desc = "[count] backward word end" },
  --- stylua: ignore
  ["<space>I"] = { "<cmd>lua my.motion.backward_WORD_end()<cr>", { "n", "x", "o" }, desc = "[count] backward WORD end" },
  -- stylua: ignore
  ["<S-space>I"] = { "<cmd>lua my.motion.backward_WORD_end()<cr>", { "n", "x", "o" }, desc = "[count] backward WORD end" },
  -- stylua: ignore
  ["<space>o"] = { "<cmd>lua my.motion.forward_word_start()<cr>", { "n", "x", "o" }, desc = "[count] forward word start", },
  -- stylua: ignore
  ["<space>O"] = { "<cmd>lua my.motion.forward_WORD_start()<cr>", { "n", "x", "o" }, desc = "[count] forward WORD start", },
  -- stylua: ignore
  ["<S-space>O"] = { "<cmd>lua my.motion.forward_WORD_start()<cr>", { "n", "x", "o" }, desc = "[count] forward WORD start", },
  -- { "lWh", "x", desc = "Forword to the start of the WORD[count](right exclusion)" },
  -- { "lwh", "x", desc = "Forword to the start of the word[count](right exclusion)" },

  ["<M-i>"] = {
    { "bi", "n", desc = "Backward to the start of word[count] and start insert mode" },
    { "<S-left>", "i" },
    {
      function()
        require("builtin.expand-select").expand_select_left_word()
      end,
      "s",
      desc = "Expand word[left]",
    },
    -- { "<C-left>", "t" },
    {
      function()
        require("builtin.cmdline").prev_word_start()
      end,
      "c",
    },
    desc = "Backward to the start of word",
  },
  ["<M-o>"] = {
    { "ea", "n", desc = "Forword to the end of the word[count] and start insert mode" },
    { "<Esc>ea", "i" },
    -- { "<C-right>", "t" },
    {
      function()
        require("builtin.expand-select").expand_select_right_word()
      end,
      "s",
      desc = "Expand word[right]",
    },
    {
      function()
        require("builtin.cmdline").next_word_end()
      end,
      "c",
    },
    desc = "Forword to the end of the word",
  },
  ["<M-space><M-i>"] = {
    { "<Esc>gea", "i" },
    {
      function()
        require("builtin.cmdline").prev_word_end()
      end,
      "c",
    },
    {
      function()
        require("builtin.expand-select").expand_select_left_word_with_blank()
      end,
      "s",
    },
    desc = "Backward to the end of word",
  },
  ["<M-space><M-o>"] = {
    { "<S-right>", "i" },
    {
      function()
        require("builtin.cmdline").next_word_start()
      end,
      "c",
    },
    {
      function()
        require("builtin.expand-select").expand_select_right_word_with_blank()
      end,
      "s",
    },
    desc = "Forword to the start of the word",
  },
  ["<M-S-i>"] = {
    { "<Esc>Bi", "i", desc = "Backward to the start of WORD" },
    { "Bi", "n", desc = "Backward to the start of WORD and start insert mode" },
    {
      function()
        require("builtin.cmdline").prev_WORD_start()
      end,
      "c",
      desc = "Backward to the start of WORD",
    },
  },
  ["<M-S-o>"] = {
    { "<Esc>Ea", "i", desc = "Forword to the end of the WORD" },
    { "Ea", "n", desc = "Forword to the end of the WORD and start insert mode" },
    {
      function()
        require("builtin.cmdline").next_WORD_end()
      end,
      "c",
      desc = "Forword to the end of the WORD",
    },
  },
  ["<M-space><M-S-i>"] = {
    {
      "<Esc>gEa",
      "i",
    },
    {
      function()
        require("builtin.cmdline").prev_WORD_end()
      end,
      "c",
    },
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-space><M-S-o>"] = {
    {
      "<C-o>W",
      "i",
    },
    {
      function()
        require("builtin.cmdline").next_WORD_start()
      end,
      "c",
    },
    desc = "Forword to the start of the word[count]",
  },
  ["<M-S-space><M-S-i>"] = {
    {
      "<Esc>gEa",
      "i",
    },
    {
      function()
        require("builtin.cmdline").prev_WORD_end()
      end,
      "c",
    },
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-S-space><M-S-o>"] = {
    {
      "<C-o>W",
      "i",
    },
    {
      function()
        require("builtin.cmdline").next_WORD_start()
      end,
      "c",
    },
    desc = "Forword to the start of the word[count]",
  },
}
