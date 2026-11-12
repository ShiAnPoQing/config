---------------------------------------------------------------------------------------------------+
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
  ["Y"] = {
    function()
      return my.operator.yank()
    end,
    "x",
    expr = true,
  },
  ["y"] = {
    {
      function()
        return my.operator.yank()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_yank_operator() then
          return "_"
        end
        return "<esc>"
      end,
      "o",
      expr = true,
    },
  },
  ["d"] = {
    {
      function()
        return my.operator.delete()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_delete_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["-"] = {
    {
      function()
        return my.operator.join()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_join_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["g-"] = {
    {
      function()
        return my.operator.join({ only_join = true })
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_join_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["gU"] = {
    {
      function()
        return my.operator.uppercase()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_uppercase_operator() then
          return "_"
        end
      end,
      "o",
      expr = true,
    },
  },
  ["gu"] = {
    {
      function()
        return my.operator.lowercase()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        if my.operator.is_lowercase_operator() then
          return "_"
        end
        return "<esc>"
      end,
      "o",
      expr = true,
    },
  },
  ["<M-c>"] = { "<C-o>c", "i", desc = "c" },
  ["<M-x>"] = { "<C-o>x", "i", desc = "x" },
  ["<M-S-`>"] = { "<C-o>~", "i", desc = "`" },
  ["<M-d>"] = { "<C-o>d", "i", desc = "d" },
  ["<M-y>"] = { "<C-o>y", "i", desc = "y" },
  ["<M-f>"] = { "<C-o>f", "i", desc = "f" },
  ["<M-t>"] = { "<C-o>t", "i", desc = "t" },
}
