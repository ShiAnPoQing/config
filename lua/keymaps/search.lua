local function select_all()
  vim.cmd("normal! vv")
  local Mark = require("utils.mark")
  local line_count = vim.api.nvim_buf_line_count(0)
  Mark.set_visual_mark(1, 0, line_count, 0)
  vim.cmd("normal! gvV")
end

return {
  -- search cursor text
  ["*"] = { "*zz", "n" },
  -- search cursor text
  ["#"] = { "#zz", "n" },
  --["%"] = { "%zz", "n" },
  -- select all
  ["<C-a>"] = {
    select_all,
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

  -- Keep window centered when going up/down
  ["n"] = {
    "nzzzv",
    "n",
  },
  ["N"] = {
    "Nzzzv",
    "n",
  },
}
