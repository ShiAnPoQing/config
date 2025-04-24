local add_new_line = require("custom.plugins.add-new-line")

return {
  ["<F5>"] = {
    function()
      add_new_line.add_new_line("down", { disable_cursor_follow = true })
    end,
    "n"
  },
  ["b"] = { "o", { "n", "x" } },
  ["B"] = { "O", { "n", "x" } },
  ["<S-CR>"] = {
    "<C-o>O",
    "i"
  },
  ["<C-CR>"] = {
    "<CR><C-U>",
    "i"
  },
  ["<C-S-CR>"] = {
    "<C-o>O<C-U>",
    "i"
  },
  -- add new line below cursor line, and cursor jump new line
  ["<M-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("down", {})
      require("repeat").Record(function()
        add_new_line.add_new_line("down", { count = count })
      end)
    end,
    "n",
  },
  -- add new line above cursor line, and cursor jump new line
  ["<C-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("up", {})
      require("repeat").Record(function()
        add_new_line.add_new_line("up", { count = count })
      end)
    end,
    { "n", "i" },
  },
  ["<C-M-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("all", {})
      require("repeat").Record(function()
        add_new_line.add_new_line("all", { count = count })
      end)
    end,
    { "n", "i" },
  }
}
