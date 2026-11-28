return {
  ["<M-j>"] = { "<down>", "s" },
  ["<M-k>"] = { "<up>", "s" },
  ["<M-h>"] = { "<left>", "s" },
  ["<M-l>"] = { "<right>", "s" },
  ["<M-S-h>"] = { "<left><left><left>", "s", desc = "3*<left>" },
  ["<M-S-j>"] = { "<down><down><down>", "s", desc = "3*<down>" },
  ["<M-S-k>"] = { "<up><up><up>", "s", desc = "3*<up>" },
  ["<M-S-l>"] = { "<right><right><right>", "s", desc = "3*<right>" },
  ["<M-space><M-space><M-l>"] = { "<End>", "s" },
  ["<M-space><M-space><M-h>"] = { "<Home>", "s" },

  -- Edit
  ["<BS>"] = { " <bs>", "s", desc = "like s" },

  ["<C-left>"] = {
    function()
      require("builtin.expand-select").expand_select_left_word()
    end,
    "s",
    desc = "Expand word[left]",
  },
  ["<C-right>"] = {
    function()
      require("builtin.expand-select").expand_select_right_word()
    end,
    "s",
    desc = "Expand word[right]",
  },

  ["<M-i>"] = {
    function()
      require("builtin.expand-select").expand_select_left_word()
    end,
    "s",
    desc = "Expand word[left]",
  },
  ["<M-o>"] = {
    function()
      require("builtin.expand-select").expand_select_right_word()
    end,
    "s",
    desc = "Expand word[right]",
  },
  ["<M-space><M-i>"] = {
    function()
      require("builtin.expand-select").expand_select_left_word_with_blank()
    end,
    "s",
    desc = "Backward to the end of word",
  },
  ["<M-space><M-o>"] = {
    function()
      require("builtin.expand-select").expand_select_right_word_with_blank()
    end,
    "s",
    desc = "Forword to the start of the word",
  },
}
