return {
  ["<C-k>"] = {
    "<Cmd>lua my.scroll.down()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] line down(cursor follow)",
  },
  ["<C-j>"] = {
    "<Cmd>lua my.scroll.up()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] line up(cursor follow)",
  },
  ["<C-l>"] = {
    "<Cmd>lua my.scroll.right()<Cr>",
    { "n", "x", "i" },
    desc = "Scroll [count] col right(cursor follow)",
  },
  ["<C-h>"] = {
    {
      "<Cmd>lua my.scroll.left()<Cr>",
      { "n", "x" },
    },
    {
      "<Cmd>lua my.scroll.left()<Cr>",
      "i",
    },
    desc = "Scroll [count] col left(cursor follow)",
  },
  ["<C-u>"] = {
    "<Cmd>lua my.scroll.half_page_up()<Cr>",
    { "n", "x" },
    desc = "Scroll [count] half page up",
  },
  ["<C-d>"] = {
    "<Cmd>lua my.scroll.half_page_down()<Cr>",
    { "n", "x" },
    desc = "Scroll [count] half page down",
  },
  ["<C-S-k>"] = {
    {
      "<Cmd>lua my.scroll.page_up()<Cr>",
      { "n", "x" },
    },
    {
      function()
        my.scroll.i_page_up()
      end,
      "i",
    },
    desc = "Scroll [count] page up",
  },
  ["<C-S-j>"] = {
    {
      "<Cmd>lua my.scroll.page_down()<Cr>",
      { "n", "x" },
    },
    {
      function()
        my.scroll.i_page_down()
      end,
      "i",
    },
    desc = "Scroll [count] page down",
  },
  ["<space><C-j>"] = {
    function()
      my.wo.only = not my.wo.only
      my.scroll.up()
    end,
    { "n", "x" },
    desc = "Scroll [count] line up(toggle cursor follow)",
  },
  ["<space><C-k>"] = {
    function()
      my.wo.only = not my.wo.only
      my.scroll.down()
    end,
    { "n", "x" },
    desc = "Scroll [count] line down(toggle cursor follow)",
  },
  ["<space><C-l>"] = {
    function()
      my.wo.only = not my.wo.only
      my.scroll.right()
    end,
    { "n", "x" },
    desc = "Scroll [count] col right(toggle cursor follow)",
  },
  ["<space><C-h>"] = {
    function()
      my.wo.only = not my.wo.only
      my.scroll.left()
    end,
    { "n", "x" },
    desc = "Scroll [count] col left(toggle cursor follow)",
  },
}
