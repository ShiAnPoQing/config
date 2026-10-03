return {
  -- Start Select Mode
  ["<M-`><M-h>"] = {
    function()
      return require("builtin.start-select-mode").left_select(1)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[h]",
  },
  ["<M-`><M-l>"] = {
    function()
      return require("builtin.start-select-mode").right_select(1)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[l]",
  },
  ["<M-`><M-j>"] = {
    function()
      return require("builtin.start-select-mode").down_select(1)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[j]",
  },
  ["<M-`><M-k>"] = {
    function()
      return require("builtin.start-select-mode").up_select(1)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[k]",
  },
  ["<M-`><M-S-h>"] = {
    function()
      return require("builtin.start-select-mode").left_select(3)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[H]",
  },
  ["<M-`><M-S-l>"] = {
    function()
      return require("builtin.start-select-mode").right_select(3)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[L]",
  },
  ["<M-`><M-S-j>"] = {
    function()
      return require("builtin.start-select-mode").down_select(3)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[J]",
  },
  ["<M-`><M-S-k>"] = {
    function()
      return require("builtin.start-select-mode").up_select(3)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[K]",
  },
  ["<M-`><M-space><M-h>"] = {
    function()
      return require("builtin.start-select-mode").select_to_first_non_blank_character()
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>h]",
  },
  ["<M-`><M-space><M-l>"] = {
    function()
      return require("builtin.start-select-mode").select_to_last_non_blank_character()
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>l]",
  },
  ["<M-`><M-space><M-space><M-h>"] = {
    function()
      return require("builtin.start-select-mode").select_to_first_character()
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space><space>h]",
  },
  ["<M-`><M-space><M-space><M-l>"] = {
    function()
      return require("builtin.start-select-mode").select_to_last_character()
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space><space>l]",
  },
  ["<M-`><M-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_end(false)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[o]",
  },
  ["<M-`><M-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_start(false)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[i]",
  },
  ["<M-`><M-S-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_end(true)
    end,
    "i",
    desc = "Start Select Mode[O]",
  },
  ["<M-`><M-S-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_start(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[I]",
  },
  ["<M-`><M-space><M-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_start(false)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>o]",
  },
  ["<M-`><M-space><M-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_end(false)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>i]",
  },
  ["<M-`><M-space><M-S-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_start(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>O]",
  },
  ["<M-`><M-space><M-S-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_end(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>I]",
  },
  ["<M-`><M-space><M-m>"] = {
    function()
      return require("builtin.start-select-mode").select_middle_of_line()
    end,
    "i",
    expr = true,
    desc = "Start Select Mode[<space>m]",
  },
  -- Start Select Block Mode
  ["<M-`><M-`><M-h>"] = {
    function()
      return require("builtin.start-select-mode").left_select(1, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[h]",
  },
  ["<M-`><M-`><M-l>"] = {
    function()
      return require("builtin.start-select-mode").right_select(1, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[l]",
  },
  ["<M-`><M-`><M-j>"] = {
    function()
      return require("builtin.start-select-mode").down_select(1, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[j]",
  },
  ["<M-`><M-`><M-k>"] = {
    function()
      return require("builtin.start-select-mode").up_select(1, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[k]",
  },
  ["<M-`><M-`><M-space><M-h>"] = {
    function()
      return require("builtin.start-select-mode").select_to_first_non_blank_character(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>h]",
  },
  ["<M-`><M-`><M-space><M-l>"] = {
    function()
      return require("builtin.start-select-mode").select_to_last_non_blank_character(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>l]",
  },
  ["<M-`><M-`><M-space><M-space><M-h>"] = {
    function()
      return require("builtin.start-select-mode").select_to_first_character(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>h]",
  },
  ["<M-`><M-`><M-space><M-space><M-l>"] = {
    function()
      return require("builtin.start-select-mode").select_to_last_character(true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>l]",
  },
  ["<M-`><M-`><M-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_end(false, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[o]",
  },
  ["<M-`><M-`><M-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_start(false, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[i]",
  },
  ["<M-`><M-`><M-S-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_end(true, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[O]",
  },
  ["<M-`><M-`><M-S-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_start(true, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[I]",
  },
  ["<M-`><M-`><M-space><M-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_start(false, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>o]",
  },
  ["<M-`><M-`><M-space><M-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_end(false, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>i]",
  },
  ["<M-`><M-`><M-space><M-S-o>"] = {
    function()
      return require("builtin.start-select-mode").select_to_next_word_start(true, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>O]",
  },
  ["<M-`><M-`><M-space><M-S-i>"] = {
    function()
      return require("builtin.start-select-mode").select_to_previous_word_end(true, true)
    end,
    "i",
    expr = true,
    desc = "Start Select Block Mode[<space>I]",
  },
  ["<C-left>"] = {
    { "<Esc>gh<S-left>", "i", desc = "Start Select Mode[i]" },
    {
      function()
        require("builtin.expand-select").expand_select_left_word()
      end,
      "s",
      desc = "Expand word[left]",
    },
  },
  ["<C-right>"] = {
    { "<C-o>ve<C-g>", "i", desc = "Start Select Mode[o]" },
    {
      function()
        require("builtin.expand-select").expand_select_right_word()
      end,
      "s",
      desc = "Expand word[right]",
    },
  },
}
