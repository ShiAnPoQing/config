return {
  -- tmux fixed
  ["<F32>"] = {
    { "<Del>", { "i", "c", "t" } },
    { "lxh", "n" },
  },
  -- tmux fixed
  ["<F6>"] = {
    function()
      require("custom.plugins.move-col-center").move_col_center("left")
    end,
    "n",
  },
  -- tmux fixed
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
}
