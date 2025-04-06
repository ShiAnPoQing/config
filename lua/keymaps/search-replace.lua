return {
  -- search cursor text
  ["*"] = { "*zz", "n" },
  -- search cursor text
  ["#"] = { "#zz", "n" },
  --["%"] = { "%zz", "n" },
  -- select all
  ["<C-a>"] = {
    "ggVG",
    "n",
  },
  -- search visual text
  ["<space>/"] = {
    'y/<C-R>"<CR>',
    "x",
  },
  -- Replace word under cursor
  ["<space>s"] = {
    {
      [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      "n",
    },
    {
      [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      "x",
    },
  },
}
