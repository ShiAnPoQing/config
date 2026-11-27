local M_j = my.keymap.keys.ALT_SPACE .. "<M-j>"
local M_k = my.keymap.keys.ALT_SPACE .. "<M-k>"
local M_h = my.keymap.keys.ALT_SPACE .. "<M-h>"
local M_l = my.keymap.keys.ALT_SPACE .. "<M-l>"

return {
  ["<M-j>"] = { "<down>", "i" },
  ["<M-k>"] = { "<up>", "i" },
  ["<M-h>"] = { "<left>", "i" },
  ["<M-l>"] = { "<right>", "i" },
  ["<M-S-h>"] = { "<left><left><left>", "i", desc = "3*<left>" },
  ["<M-S-j>"] = { "<down><down><down>", "i", desc = "3*<down>" },
  ["<M-S-k>"] = { "<up><up><up>", "i", desc = "3*<up>" },
  ["<M-S-l>"] = { "<right><right><right>", "i", desc = "3*<right>" },
  ["<M-g><M-j>"] = { "<C-g><C-j>", "i", desc = "Down[insert start column]" },
  ["<M-g><M-k>"] = { "<C-g><C-k>", "i", desc = "Up[insert start column]" },
  ["<M-space>j"] = { "<C-o>L", "i" },
  ["<M-space>k"] = { "<C-o>H", "i" },
  ["<M-space>m"] = { "<C-o>gm", "i" },
  ["<M-space>n"] = { "<C-o>M", "i" },
  [M_k] = { "<up><end>", "i" },
  [M_j] = { "<down><end>", "i" },
  -- stylua: ignore
  [M_h] = { "<cmd>lua my.motion.first_non_blank()<cr>", "i", desc = "Move to the first non-blank character", },
  -- stylua: ignore
  [M_l] = { "<cmd>lua my.motion.last_non_blank()<cr>", "i", desc = "Move to the last non-blank character", },
  ["<M-space><M-space><M-k>"] = { "<up><home>", "i" },
  ["<M-space><M-space><M-j>"] = { "<down><home>", "i" },
  ["<M-space><M-space><M-h>"] = { "<End>", "i" },
  ["<M-space><M-space><M-l>"] = { "<Home>", "i" },
  ["<M-a><M-h>"] = { "<C-o>g^", "i", desc = "Screen First Character" },
  ["<M-a><M-l>"] = { "<esc>g<end>a", "i", desc = "Screen Last Character" },
  ["<M-a><M-a><M-h>"] = { "<C-o>g0", "i", desc = "Screen First Character" },
  ["<M-a><M-a><M-l>"] = { "<esc>g$a", "i", desc = "Screen Last Character" },
  -- stylua: ignore
  ["<M-2><M-l>"] = { "<C-o>ze", "i", desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.", },
  -- stylua: ignore
  ["<M-2><M-h>"] = { "<C-o>zs", "i", desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.", },
  -- stylua: ignore
  ["<M-2><M-k>"] = { "<C-o>zt", "i", desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).", },
  -- stylua: ignore
  ["<M-2><M-j>"] = { "<C-o>zb", "i", desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).", },
  -- stylua: ignore
  ["<M-2><M-n>"] = { "<C-o>zz", "i", desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).", },
  ["<M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-1><M-h>"] = { "<C-o>g^", "i" },
  ["<M-1><M-l>"] = { "<esc>g<end>a", "i" },
  ["<M-1><M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-1><M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-1><M-1><M-h>"] = { "<C-o>g0", "i" },
  ["<M-1><M-1><M-l>"] = { "<C-o>g$", "i" },
  ["<M-w><M-k>"] = { "<C-o>-", "i" },
  ["<M-e><M-k>"] = { "<Esc>kg_a", "i" },
  ["<M-w><M-j>"] = { "<C-o>+", "i" },
  ["<M-e><M-j>"] = { "<Esc>jg_a", "i" },
  ["<M-w><M-w><M-k>"] = { "<Esc>k0i", "i" },
  ["<M-e><M-e><M-k>"] = { "<Esc>k$a", "i" },
  ["<M-w><M-w><M-j>"] = { "<C-o>j0i", "i" },
  ["<M-e><M-e><M-j>"] = { "<Esc>j$a", "i" },
  -- stylua: ignore
  ["<M-i>"] = { "<S-left>", "i", desc = "[motion]: backward word start", },
  -- stylua: ignore
  ["<M-o>"] = { "<Esc>ea", "i", desc = "[motion]: forward word end", },
  ["<M-space><M-i>"] = { "<Esc>gea", "i", desc = "[motion]: backward word end" },
  ["<M-space><M-o>"] = { "<S-right>", "i", desc = "[motion]: forward word start" },
  -- stylua: ignore
  ["<M-S-i>"] = { "<Esc>Bi", "i", desc = "[motion]: backward WORD start", },
  ["<M-S-o>"] = { "<Esc>Ea", "i", desc = "[motion]: forward WORD end" },
  ["<M-space><M-S-i>"] = { "<Esc>gEa", "i", desc = "[motion]: backward WORD end" },
  ["<M-space><M-S-o>"] = { "<C-o>W", "i", desc = "[motion]: forward WORD start" },
  ["<M-S-space><M-S-i>"] = { "<Esc>gEa", "i", desc = "[motion]: backward WORD end" },
  ["<M-S-space><M-S-o>"] = { "<C-o>W", "i", desc = "[motion]: forward WORD start" },

  --- Edit
  ["<S-BS>"] = { "<Del>", "i", desc = "Delete character after the cursor" },
  [my.keymap.keys.CTRL_BS] = {
    -- Issue: insert mode -> normal mode: 有闪烁，特别是 lsp 诊断
    -- '<Left><C-o>"_diw',
    function()
      my.edit["i"].delete_cword(true)
    end,
    "i",
    desc = "Delete cword(before)",
  },
  ["<M-BS>"] = {
    -- Issue: insert mode -> normal mode: 有闪烁，特别是 lsp 诊断
    -- '<C-o>"_diw'
    function()
      my.edit["i"].delete_cword()
    end,
    "i",
    desc = "Delete the cword(after)",
  },
  ["<C-S-BS>"] = {
    -- '<Left><C-o>"_diW',
    function()
      my.edit["i"].delete_cWORD(true)
    end,
    "i",
    desc = "Delete the CWORD(before)",
  },
  ["<M-S-BS>"] = {
    -- '<C-o>"_diW',
    function()
      my.edit["i"].delete_cWORD()
    end,
    "i",
    desc = "Delete the CWORD(after)",
  },
  ["<C-i>"] = { "<C-w>", "i", desc = "Delete the part of the word before the cursor" },
  ["<C-o>"] = {
    function()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc .. 'veol"_c', "n", false)
    end,
    "i",
    desc = "Delete the part of the word after the cursor",
  },
  ["<C-S-i>"] = {
    function()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc .. 'vB"_c', "n", false)
    end,
    "i",
    desc = "Delete the part of the WORD before the cursor",
  },
  ["<C-S-o>"] = {
    function()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc .. 'vEol"_c', "n", false)
    end,
    "i",
    desc = "Delete the part of the WORD after the cursor",
  },
  ["<C-space><C-i>"] = {
    function()
      my.edit["i"].delete_to_prev_word_end()
    end,
    "i",
    desc = "[edit]: delete to previous word end",
  },
  ["<C-space><C-o>"] = {
    '<C-o>"_dw',
    "i",
    desc = "[edit]: delete to next word start",
  },
  ["<C-space><C-S-i>"] = {
    '<C-o>"_dgE',
    "i",
    desc = "[edit]: delete to previous WORD end",
  },
  ["<C-S-space><C-S-i>"] = {
    '<C-o>"_dgE',
    "i",
    desc = "[edit]: delete to previous WORD end",
  },
  ["<C-space><C-S-O>"] = {
    '<C-o>"_dW',
    "i",
    desc = "[edit]: delete to next WORD start",
  },
  ["<C-S-space><C-S-O>"] = {
    '<C-o>"_dW',
    "i",
    desc = "[edit]: delete to next WORD start",
  },
  ["<C-u>"] = {
    "<C-G>u<C-u>",
    "i",
    desc = "Delete up to the first non-blank character of the current line",
  },
  ["<M-u>"] = {
    '<C-o>"_dg_',
    "i",
    desc = "Delete up to the last non-blank character of the current line",
  },
  ["<C-M-u>"] = { '<Esc>"_cc', "i", desc = "Delete the current line" },
  ["<C-space><C-u>"] = {
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
  ["<M-space><M-u>"] = {
    '<C-o>"_d$',
    "i",
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

  --- Indent
  ["<C-.>"] = { "<C-T>", "i", desc = "Insert one shiftwidth of indent at the start of the current line" },
  ["<C-,>"] = { "<C-D>", "i", desc = "Delete one shiftwidth of indent at the start of the current line" },
  ["<C-space><C-,>"] = { "^<C-D>", "i", desc = "Delete all indent in the current line" },
  ["<C-space><C-.>"] = { "^<C-D>", "i", desc = "Delete all indent in the current line" },

  --- Start Select Mode
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
    "<Esc>gh<S-left>",
    "i",
    desc = "Start Select Mode[i]",
  },
  ["<C-right>"] = {
    "<C-o>ve<C-g>",
    "i",
    desc = "Start Select Mode[o]",
  },

  --- Operator
  ["<M-c>"] = { "<C-o>c", "i", desc = "c" },
  ["<M-x>"] = { "<C-o>x", "i", desc = "x" },
  ["<M-S-`>"] = { "<C-o>~", "i", desc = "`" },
  ["<M-d>"] = { "<C-o>d", "i", desc = "d" },
  ["<M-y>"] = { "<C-o>y", "i", desc = "y" },
  ["<M-f>"] = { "<C-o>f", "i", desc = "f" },
  ["<M-t>"] = { "<C-o>t", "i", desc = "t" },
}
