--- ghostty tmux fixed

if vim.env.TERM ~= "tmux-256color" and vim.env.TERM ~= "xterm-ghostty" then
  return {}
end

return {
  -- Tmux <S-BS> is not working
  ["<F32>"] = {
    { "<Del>", { "i", "c", "t" } },
    { "lxh", "n" },
  },
  -- ["<F6>"] = {
  --   function()
  --     require("custom.plugins.move-col-center").move_col_center("left")
  --   end,
  --   "n",
  -- },
  -- tmux <C-BS> is not working
  ["<F31>"] = {
    { "<Left><C-o>diw", "i" },
    {
      function()
        require("builtin.cmdline").delete_current_word_before()
      end,
      "c",
      desc = "Delete current word(before)",
    },
  },
  -- tmux <C-/> is not working
  ["<F33>"] = {
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
  },
}
