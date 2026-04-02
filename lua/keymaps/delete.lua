---------------------------------------------------------------------------------------------------+
-- Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- ================================================================================================+
-- map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
---------------------------------------------------------------------------------------------------+

local function ctrl_space_ctrl_i()
  vim.cmd.stopinsert()
  local end_pos = vim.api.nvim_win_get_cursor(0)
  local end_row = end_pos[1]
  local end_col = end_pos[2]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("hgel", true, false, true), "nx", false)
  local start_pos = vim.api.nvim_win_get_cursor(0)
  local start_row = start_pos[1]
  local start_col = start_pos[2]

  if start_row == end_row then
    vim.api.nvim_buf_set_text(0, start_row - 1, start_col, start_row - 1, end_col, { "" })
    vim.api.nvim_feedkeys("a", "n", false)
    return
  end

  if end_col ~= 0 then
    vim.api.nvim_buf_set_text(0, end_row - 1, 0, end_row - 1, end_col, { "" })
  end

  if start_col > 0 then
    vim.api.nvim_feedkeys("a", "n", false)
  else
    vim.api.nvim_feedkeys("i", "n", false)
  end
end

return {
  ["<BS>"] = {
    { "s", "n", desc = "same as 's'" },
    { "d", "x", desc = "same as 'd'" },
    { " <bs>", "s" },
  },
  ["<S-BS>"] = {
    { "<Del>", { "i", "c", "t" } },
    { "x", "n" },
    desc = "Delete character after the cursor",
  },
  ["<C-BS>"] = {
    { '<Left><C-o>"_diw', "i" },
    { '"_diw', "n" },
    {
      function()
        require("builtin.cmdline").delete_cword_before()
      end,
      "c",
    },
    desc = "Delete cword(before)",
  },
  ["<M-BS>"] = {
    { '<C-o>"_diw', "i" },
    { '"_diw', "n" },
    {
      function()
        require("builtin.cmdline").delete_cword_after()
      end,
      "c",
    },
    desc = "Delete the cword(after)",
  },
  ["<C-S-BS>"] = {
    {
      '<Left><C-o>"_diW',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_CWORD_before()
      end,
      "c",
    },
    desc = "Delete the CWORD(before)",
  },
  ["<M-S-BS>"] = {
    { '<C-o>"_diW', "i" },
    {
      function()
        require("builtin.cmdline").delete_CWORD_after()
      end,
      "c",
    },
    desc = "Delete the CWORD(after)",
  },
  ["<C-i>"] = {
    {
      --- TODO: Undo Block
      function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. 'vb"_c', "n", false)
      end,

      "i",
    },
    { "<C-w>", "c" },
    desc = "Delete the part of the word before the cursor",
  },
  ["<C-o>"] = {
    {
      function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. 'veol"_c', "n", false)
      end,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_next_word_end()
      end,
      "c",
    },
    desc = "Delete the part of the word after the cursor",
  },
  ["<C-S-i>"] = {
    {
      function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. 'vB"_c', "n", false)
      end,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_prev_WORD_start()
      end,
      "c",
    },
    desc = "Delete the part of the WORD before the cursor",
  },
  ["<C-S-o>"] = {
    {
      function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. 'vEol"_c', "n", false)
      end,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_next_WORD_end()
      end,
      "c",
    },
    desc = "Delete the part of the WORD after the cursor",
  },
  ["<C-space><C-i>"] = {
    {
      ctrl_space_ctrl_i,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_prev_word_end()
      end,
      "c",
    },
    desc = "Delete up to the end of the previous word",
  },
  ["<C-space><C-o>"] = {
    { '<C-o>"_dw', "i" },
    {
      function()
        require("builtin.cmdline").delete_to_next_word_start()
      end,
      "c",
    },
    desc = "Delete up to the start of the next word",
  },
  ["<C-space><C-S-i>"] = {
    {
      '<C-o>"_dgE',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_prev_WORD_end()
      end,
      "c",
    },
    desc = "Delete up to the end of the previous WORD",
  },
  ["<C-S-space><C-S-i>"] = {
    {
      '<C-o>"_dgE',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_prev_WORD_end()
      end,
      "c",
    },
    desc = "Delete up to the end of the previous WORD",
  },
  ["<C-space><C-S-O>"] = {
    {
      '<C-o>"_dW',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_next_WORD_start()
      end,
      "c",
    },
    desc = "Delete up to the start of the next WORD",
  },
  ["<C-S-space><C-S-O>"] = {
    {
      '<C-o>"_dW',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_next_WORD_start()
      end,
      "c",
    },
    desc = "Delete up to the start of the next WORD",
  },
  ["<C-u>"] = {
    {
      "<C-G>u<C-u>",
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_first_non_blank_character()
      end,
      "c",
    },
    desc = "Delete up to the first non-blank character of the current line",
  },
  ["<M-u>"] = {
    {
      '<C-o>"_dg_',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_last_non_blank_character()
      end,
      "c",
    },
    desc = "Delete up to the last non-blank character of the current line",
  },
  ["<C-M-u>"] = { '<Esc>"_cc', "i", desc = "Delete the current line" },
  ["<C-space><C-u>"] = {
    {
      function()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local delete = '<C-o>"_d0'
        if cursor[2] == #line then
          return delete .. "<del>"
        end
        return delete
      end,
      "i",
      expr = true,
    },
    {
      function()
        require("builtin.cmdline").delete_to_first_character()
      end,
      "c",
    },
    desc = "Delete up to the first character of the current line",
  },
  ["<M-space><M-u>"] = {
    {
      '<C-o>"_d$',
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_last_character()
      end,
      "c",
    },
    desc = "Delete up to the last character of the current line",
  },
  ["<C-space><C-h>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local delete = '<C-o>"_d^'
      if cursor[2] == #line then
        return delete .. "<del>"
      end
      return delete
    end,
    "i",
    expr = true,
    desc = "Delete up to the first non-blank character of the current line",
  },
  ["<C-space><C-l>"] = { '<C-o>"_dg_', "i", desc = "Delete up to the last non-blank character of the current line" },
  ["<C-space><C-space><C-h>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local delete = '<C-o>"_d0'
      if cursor[2] == #line then
        return delete .. "<del>"
      end
      return delete
    end,
    "i",
    expr = true,
    desc = "Delete up to the first character of the current line",
  },
  ["<C-space><C-space><C-l>"] = { '<C-o>"_d$', "i", desc = "Delete up to the last character of the current line" },
  ["<C-a><C-h>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local delete = '<C-o>"_dg^'
      if cursor[2] == #line then
        return delete .. "<bs>"
      end
      return delete
    end,
    "i",
    expr = true,
    desc = "Delete up to the first non-blank character of the screen line",
  },
  ["<C-a><C-l>"] = {
    '<C-o>"_dg<End>',
    "i",
    desc = "Delete up to the last non-blank character of the screen line",
  },
  ["<C-a><C-a><C-h>"] = {
    function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local delete = '<C-o>"_dg0'
      if cursor[2] == #line then
        return delete .. "<bs>"
      end
      return delete
    end,
    "i",
    expr = true,
    desc = "Delete up to the first character of the screen line",
  },
  ["<C-a><C-a><C-l>"] = { '<C-o>"_dg$', "i", desc = "Delete up to the end character of the screen line" },
}
