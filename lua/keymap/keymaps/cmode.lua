return {
  ["<M-j>"] = { "<down>", "c" },
  ["<M-k>"] = { "<up>", "c" },
  ["<M-h>"] = { "<left>", "c" },
  ["<M-l>"] = { "<right>", "c" },
  ["<M-S-h>"] = { "<left><left><left>", "c" },
  ["<M-S-j>"] = { "<down><down><down>", "c" },
  ["<M-S-k>"] = { "<up><up><up>", "c" },
  ["<M-S-l>"] = { "<right><right><right>", "c" },
  ["<M-i>"] = {
    function()
      require("builtin.cmdline").prev_word_start()
    end,
    "c",
    desc = "Backward to the start of word",
  },
  ["<M-o>"] = {
    function()
      require("builtin.cmdline").next_word_end()
    end,
    "c",
    desc = "Forword to the end of the word",
  },
  ["<M-space><M-i>"] = {
    function()
      require("builtin.cmdline").prev_word_end()
    end,
    "c",
    desc = "Backward to the end of word",
  },
  ["<M-space><M-o>"] = {
    function()
      require("builtin.cmdline").next_word_start()
    end,
    "c",
    desc = "Forword to the start of the word",
  },
  ["<M-S-i>"] = {
    function()
      require("builtin.cmdline").prev_WORD_start()
    end,
    "c",
    desc = "Backward to the start of WORD",
  },
  ["<M-S-o>"] = {
    function()
      require("builtin.cmdline").next_WORD_end()
    end,
    "c",
    desc = "Forword to the end of the WORD",
  },

  ["<M-space><M-S-i>"] = {
    function()
      require("builtin.cmdline").prev_WORD_end()
    end,
    "c",
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-space><M-S-o>"] = {
    function()
      require("builtin.cmdline").next_WORD_start()
    end,
    "c",
    desc = "Forword to the start of the word[count]",
  },
  ["<M-S-space><M-S-i>"] = {
    function()
      require("builtin.cmdline").prev_WORD_end()
    end,
    "c",
    desc = "Backward to the end of WORD[count]",
  },
  ["<M-S-space><M-S-o>"] = {
    function()
      require("builtin.cmdline").next_WORD_start()
    end,
    "c",
    desc = "Forword to the start of the word[count]",
  },

  ["<S-BS>"] = { "<Del>", "c", desc = "Delete character after the cursor" },
  ["<C-bs>"] = {
    function()
      require("builtin.cmdline").delete_cword_before()
    end,
    "c",
    desc = "Delete cword(before)",
  },
  ["<M-BS>"] = {
    function()
      require("builtin.cmdline").delete_cword_after()
    end,
    "c",
    desc = "Delete the cword(after)",
  },
  ["<C-S-BS>"] = {
    function()
      require("builtin.cmdline").delete_CWORD_before()
    end,
    "c",
    desc = "Delete the CWORD(before)",
  },
  ["<M-S-BS>"] = {
    function()
      require("builtin.cmdline").delete_CWORD_after()
    end,
    "c",
    desc = "Delete the CWORD(after)",
  },
  ["<C-i>"] = {
    -- {
    --   --- TODO: Undo Block
    --   function()
    --     local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    --     vim.api.nvim_feedkeys(esc .. 'vb"_c', "n", false)
    --   end,
    --   "i",
    -- },
    "<C-w>",
    "c",
    desc = "Delete the part of the word before the cursor",
  },
  ["<C-o>"] = {
    function()
      require("builtin.cmdline").delete_to_next_word_end()
    end,
    "c",
    desc = "Delete the part of the word after the cursor",
  },
  ["<C-S-i>"] = {
    function()
      require("builtin.cmdline").delete_to_prev_WORD_start()
    end,
    "c",
    desc = "Delete the part of the WORD before the cursor",
  },
  ["<C-S-o>"] = {
    function()
      require("builtin.cmdline").delete_to_next_WORD_end()
    end,
    "c",
    desc = "Delete the part of the WORD after the cursor",
  },
  ["<C-space><C-i>"] = {
    function()
      require("builtin.cmdline").delete_to_prev_word_end()
    end,
    "c",
    desc = "Delete up to the end of the previous word",
  },
  ["<C-space><C-o>"] = {
    function()
      require("builtin.cmdline").delete_to_next_word_start()
    end,
    "c",
    desc = "Delete up to the start of the next word",
  },
  ["<C-space><C-S-i>"] = {
    function()
      require("builtin.cmdline").delete_to_prev_WORD_end()
    end,
    "c",
    desc = "Delete up to the end of the previous WORD",
  },
  ["<C-S-space><C-S-i>"] = {
    function()
      require("builtin.cmdline").delete_to_prev_WORD_end()
    end,
    "c",
    desc = "Delete up to the end of the previous WORD",
  },
  ["<C-space><C-S-O>"] = {
    function()
      require("builtin.cmdline").delete_to_next_WORD_start()
    end,
    "c",
    desc = "Delete up to the start of the next WORD",
  },
  ["<C-S-space><C-S-O>"] = {
    function()
      require("builtin.cmdline").delete_to_next_WORD_start()
    end,
    "c",
    desc = "Delete up to the start of the next WORD",
  },
  ["<C-u>"] = {
    function()
      require("builtin.cmdline").delete_to_first_non_blank_character()
    end,
    "c",
    desc = "Delete up to the first non-blank character of the current line",
  },
  ["<M-u>"] = {
    function()
      require("builtin.cmdline").delete_to_last_non_blank_character()
    end,
    "c",
    desc = "Delete up to the last non-blank character of the current line",
  },
  ["<C-space><C-u>"] = {
    function()
      require("builtin.cmdline").delete_to_first_character()
    end,
    "c",
    desc = "Delete up to the first character of the current line",
  },
  ["<M-space><M-u>"] = {
    function()
      require("builtin.cmdline").delete_to_last_character()
    end,
    "c",
    desc = "Delete up to the last character of the current line",
  },
}
