return {
  ["<C-W>"] = {
    "<nop>",
    "c",
  },
  ["<M-Space><M-h>"] = {
    function()
      require("builtin.cmdline").first_non_blank_character()
    end,
    "c",
    desc = "Move to the first non-blank character of the cmdline",
  },
  ["<M-Space><M-l>"] = {
    function()
      require("builtin.cmdline").last_non_blank_character()
    end,
    "c",
    desc = "Move to the last non-blank character of the cmdline",
  },
  ["<M-Space><M-Space><M-h>"] = {
    "<Home>",
    "c",
    desc = "Move to <Home>",
  },
  ["<M-Space><M-Space><M-l>"] = {
    "<End>",
    "c",
    desc = "Move to <End>",
  },
  ["<M-o>"] = {
    function()
      require("builtin.cmdline").word_end_forward()
    end,
    "c",
    desc = "Move to the end of next word",
  },
  ["<M-i>"] = {
    function()
      require("builtin.cmdline").word_start_backward()
    end,
    "c",
    desc = "Move to the start of previous word",
  },
  ["<C-M-o>"] = {
    function()
      require("builtin.cmdline").word_start_forward()
    end,
    "c",
    desc = "Move to the start of next word",
  },
  ["<C-M-i>"] = {
    function()
      require("builtin.cmdline").word_end_backward()
    end,
    "c",
    desc = "Move to the end of previous word",
  },
  ["<M-Space><M-o>"] = {
    function()
      require("builtin.cmdline").word_start_forward()
    end,
    "c",
    desc = "Move to the start of next word",
  },
  ["<M-Space><M-i>"] = {
    function()
      require("builtin.cmdline").word_end_backward()
    end,
    "c",
    desc = "Move to the end of previous word",
  },
  ["<C-o>"] = {
    function()
      require("builtin.cmdline").delete_to_word_end_forward()
    end,
    "c",
    desc = "Delete to the end of next word",
  },
  ["<C-i>"] = {
    "<C-w>",
    "c",
    desc = "Delete to the start of previous word",
    replace_keycodes = true,
  },
  ["<C-Space><C-o>"] = {
    function()
      require("builtin.cmdline").delete_to_word_start_forward()
    end,
    "c",
    desc = "Delete to the start of next word",
  },
  ["<C-Space><C-i>"] = {
    function()
      require("builtin.cmdline").delete_to_word_end_backward()
    end,
    "c",
    desc = "Delete to the end of previous word",
  },
  --- <C-BS>
  ["<F31>"] = {
    function()
      require("builtin.cmdline").delete_current_word_before()
    end,
    "c",
    desc = "Delete current word(before)",
  },
  ["<M-BS>"] = {
    function()
      require("builtin.cmdline").delete_current_word_after()
    end,
    "c",
    desc = "Delete current word(after)",
  },
  ["<M-S-h>"] = {
    "<left><left><left>",
    "c",
  },
  ["<M-S-l>"] = {
    "<right><right><right>",
    "c",
  },
}
