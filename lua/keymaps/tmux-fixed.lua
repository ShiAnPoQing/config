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
  --- @see keymaps/delete.lua <C-BS>
  ["<F17>"] = {
    { "<Left><C-o>diw", "i" },
    {
      function()
        require("builtin.cmdline").delete_cword_before()
      end,
      "c",
    },
    desc = "Delete the cword(before)",
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
  -- <C-S-BS>
  --- @see keymaps/delete.lua <C-BS>
  ["<F20>"] = {
    { "<Left><C-o>diW", "i" },
    {
      function()
        vim.print("hao")
        require("builtin.cmdline").delete_CWORD_before()
      end,
      "c",
    },
    desc = "Delete the cword(before)",
  },
  -- <M-S-BS>
  ["<F21>"] = {
    { "<C-o>diW", "i" },
    {
      function()
        vim.print("hao")
        require("builtin.cmdline").delete_CWORD_after()
      end,
      "c",
    },
    desc = "Delete the CWORD(after)",
  },
  -- ["<F6>"] = {
  --   function()
  --     require("custom.plugins.move-col-center").move_col_center("left")
  --   end,
  --   "n",
  -- },
}
