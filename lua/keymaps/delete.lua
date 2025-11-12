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
  ["<S-BS>"] = { { "<Del>", { "i", "c", "t" } }, { "x", "n" }, desc = "Delete char after cursor" },
  ["<C-BS>"] = { "<Left><C-o>diw", "i", desc = "Delete the word where the cursor is(before)" },
  ["<M-BS>"] = {
    { "<C-o>diw", "i" },
    {
      function()
        require("builtin.cmdline").delete_current_word_after()
      end,
      "c",
    },
    desc = "Delete the word where the cursor is(after)",
  },
  ["<C-i>"] = {
    {
      function()
        local function delete()
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          vim.api.nvim_feedkeys(esc .. "ldbi", "n", false)
        end

        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        if cursor[2] == #line then
          ---@diagnostic disable-next-line: undefined-field
          local virtualedit = vim.opt_local.virtualedit:get()[1]
          if virtualedit ~= "all" then
            vim.opt_local.virtualedit = "all"
            delete()
            vim.schedule(function()
              vim.opt_local.virtualedit = virtualedit
            end)
            return
          end
        end
        delete()
      end,
      "i",
    },
    {
      "<C-w>",
      "c",
      replace_keycodes = true,
    },
    desc = "Delete to the beginning of the word",
  },
  ["<C-o>"] = {
    {
      function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. "veolc", "n", false)
      end,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_word_end_forward()
      end,
      "c",
    },
    desc = "Delete to the end of the word",
  },
  ["<C-S-i>"] = {
    function()
      local function delete()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc .. "ldBi", "n", false)
      end
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      if cursor[2] == #line then
        ---@diagnostic disable-next-line: undefined-field
        local virtualedit = vim.opt_local.virtualedit:get()[1]
        if virtualedit ~= "all" then
          vim.opt_local.virtualedit = "all"
          delete()
          vim.schedule(function()
            vim.opt_local.virtualedit = virtualedit
          end)
          return
        end
      end
      delete()
    end,
    "i",
    desc = "Delete to the beginning of the WORD",
  },
  ["<C-S-o>"] = {
    function()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc .. "vEolc", "n", false)
    end,
    "i",
    desc = "Delete to the end of the WORD",
  },
  ["<C-space><C-i>"] = {
    {
      ctrl_space_ctrl_i,
      "i",
    },
    {
      function()
        require("builtin.cmdline").delete_to_word_end_backward()
      end,
      "c",
    },
    desc = "Delete to the end of the previous word",
  },
  ["<C-space><C-o>"] = {
    { "<C-o>dw", "i" },
    {
      function()
        require("builtin.cmdline").delete_to_word_start_forward()
      end,
      "c",
    },
    desc = "Delete to the beginning of the next word",
  },
  ["<C-space><C-S-i>"] = { "<C-o>dgE", "i", desc = "Delete to the end of the previous WORD" },
  ["<C-space><C-S-O>"] = { "<C-o>dW", "i", desc = "Delete to the beginning of the next WORD" },
  ["<C-u>"] = { "<C-G>u<C-u>", "i", desc = "Delete to the first non-blank character of the current line" },
  ["<M-u>"] = { "<C-o>dg_", "i", desc = "Delete to the last non-blank character of the current line" },
  ["<C-space><C-u>"] = { "<C-o>d0", "i", desc = "Delete to the first character of the current line" },
  ["<M-space><M-u>"] = { "<C-o>d$", "i", desc = "Delete to the last character of the current line" },
  ["<C-space><C-h>"] = { "<C-o>d^", "i", desc = "Delete to the first non-blank character of the current line" },
  ["<C-space><C-l>"] = { "<C-o>dg_", "i", desc = "Delete to the end non-blank character of the current  line" },
  ["<C-space><C-space><C-h>"] = { "<C-o>d0", "i", desc = "Delete to the first character of the current line" },
  ["<C-space><C-space><C-l>"] = { "<C-o>d$", "i", desc = "Delete to the end character of the current line" },
  ["<C-a><C-h>"] = { "<C-o>dg^", "i", desc = "Delete to the first non-blank character of the screen line" },
  ["<C-a><C-l>"] = { "<C-o>dg<End>", "i", desc = "Delete to the end non-blank character of the screen line" },
  ["<C-a><C-a><C-h>"] = { "<C-o>dg0", "i", desc = "Delete to the first character of the screen line" },
  ["<C-a><C-a><C-l>"] = { "<C-o>dg$", "i", desc = "Delete to the end character of the screen line" },
  ["<C-M-u>"] = { "<C-G>u<C-u><C-o>d$", "i", desc = "Delete the current line" },
}
