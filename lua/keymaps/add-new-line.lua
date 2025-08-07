local add_new_line = require("custom.plugins.add-new-line")

return {
  ["b"] = { "o", { "n", "x" } },
  ["B"] = { "O", { "n", "x" } },
  -- no blank
  ["<space>b"] = { "o<C-u>", { "n" } },
  -- no blank
  ["<space>B"] = { "O<C-u>", { "n" } },
  ["<S-CR>"] = {
    "<C-o>O",
    "i",
  },
  -- no blank
  ["<C-CR>"] = {
    "<CR><C-U>",
    "i",
  },
  -- no blank
  ["<C-S-CR>"] = {
    "<C-o>O<C-U>",
    "i",
  },
  -- add new line below cursor line, and cursor jump new line
  ["<M-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("down", {})
      require("repeat").record({
        name = "add-new-line",
        callback = function()
          add_new_line.add_new_line("down", {})
        end,
      })
    end,
    "n",
  },
  -- add new line above cursor line, and cursor jump new line
  ["<C-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("up", {})
    end,
    { "n", "i" },
  },
  ["<C-M-b>"] = {
    function()
      local count = vim.v.count1
      add_new_line.add_new_line("all", {})
    end,
    { "n", "i" },
  },
}
