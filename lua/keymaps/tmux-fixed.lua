--- ghostty tmux fixed

if vim.env.TERM ~= "tmux-256color" and vim.env.TERM ~= "xterm-ghostty" then
  return {}
end

return {
  -- <M-left>
  ["<F13>"] = {
    function()
      require("builtin.window-resize").resize("decrease", "horizontal")
    end,
    "n",
  },
  -- <M-right>
  ["<F14>"] = {
    function()
      require("builtin.window-resize").resize("increase", "horizontal")
    end,
    "n",
  },
  --- <M-up>
  ["<F15>"] = {
    function()
      require("builtin.window-resize").resize("decrease", "vertical")
    end,
    "n",
  },
  --- <M-down>
  ["<F16>"] = {
    function()
      require("builtin.window-resize").resize("increase", "vertical")
    end,
    "n",
  },
  -- <C-BS>
  ["<F17>"] = {
    { "<Left><C-o>diw", "i" },
    {
      function()
        require("builtin.cmdline").delete_current_word_before()
      end,
      "c",
      desc = "Delete current word(before)",
    },
  },
  -- <S-BS>
  ["<F18>"] = {
    { "<Del>", { "i", "c", "t" } },
    { "lxh", "n" },
  },
  -- <C-/>
  ["<F19>"] = {
    {
      function()
        return require("vim._comment").operator() .. "_"
      end,
      "n",
      expr = true,
      desc = "Toggle comment line",
    },
    {
      function()
        return require("vim._comment").operator()
      end,
      "x",
      expr = true,
      desc = "Toggle Comment",
    },
    {
      function()
        require("vim._comment").textobject()
      end,
      "o",
      desc = "Comment textobject",
    },
    {
      function()
        return "<Esc>" .. require("vim._comment").operator() .. "_a"
      end,
      "i",
      desc = "Toggle Comment",
      expr = true,
    },
  },
  -- ["<F6>"] = {
  --   function()
  --     require("custom.plugins.move-col-center").move_col_center("left")
  --   end,
  --   "n",
  -- },
}
