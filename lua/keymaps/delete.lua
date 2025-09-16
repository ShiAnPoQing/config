local function ctrl_space_ctrl_i()
  vim.cmd.stopinsert()
  vim.schedule(function()
    local end_pos = vim.api.nvim_win_get_cursor(0)
    local end_row = end_pos[1]
    local end_col = end_pos[2]
    vim.api.nvim_exec2(
      [[
    exec "normal! ge"
    ]],
      {}
    )
    local start_pos = vim.api.nvim_win_get_cursor(0)
    local start_row = start_pos[1]
    local start_col = start_pos[2]

    if start_row == end_row then
      vim.api.nvim_buf_set_text(0, start_row - 1, start_col + 1, start_row - 1, end_col + 1, { "" })
      vim.api.nvim_feedkeys("a", "n", false)
      return
    end

    if end_col ~= 0 then
      vim.api.nvim_buf_set_text(0, end_row - 1, 0, end_row - 1, end_col + 1, { "" })
    end

    if start_col > 0 then
      vim.api.nvim_feedkeys("a", "n", false)
    else
      vim.api.nvim_feedkeys("i", "n", false)
    end
  end)
end

return {
  ["<S-BS>"] = {
    { "<Del>", { "i", "c", "t" } },
    { "lxh", "n" },
    desc = "Delete char after cursor",
  },
  ["<C-BS>"] = {
    "<Left><C-o>diw",
    "i",
    desc = "Delete the word where the cursor is(before)",
  },
  ["<M-BS>"] = {
    "<C-o>diw",
    "i",
    desc = "Delete the word where the cursor is(after)",
  },
  ["<C-M-BS>"] = {
    "<nop>",
    "i",
    desc = "待定",
  },

  ["<C-i>"] = {
    "<Esc>ldbi",
    "i",
    noremap = true,
    desc = "Delete to the beginning of the word",
  },
  ["<C-o>"] = {
    "<C-o>de",
    "i",
    noremap = true,
    desc = "Delete to the end of the word",
  },
  ["<C-S-i>"] = {
    "<C-o>dB",
    "i",
    noremap = true,
    desc = "Delete to the beginning of the WORD",
  },
  ["<C-S-o>"] = {
    "<C-o>dE",
    "i",
    noremap = true,
    desc = "Delete to the end of the WORD",
  },
  ["<C-Space><C-i>"] = {
    ctrl_space_ctrl_i,
    "i",
    noremap = true,
    desc = "Delete to the end of the previous word",
  },
  ["<C-Space><C-o>"] = {
    "<C-o>dw",
    "i",
    noremap = true,
    desc = "Delete to the beginning of the next word",
  },
  ["<C-Space><C-S-i>"] = {
    "<C-o>dgE",
    "i",
    desc = "Delete to the end of the previous WORD",
  },
  ["<C-Space><C-S-O>"] = {
    "<C-o>dW",
    "i",
    noremap = true,
    desc = "Delete to the beginning of the next WORD",
  },

  ["<C-u>"] = {
    "<C-G>u<C-u>",
    "i",
    desc = "Delete to the first non-blank character of the current line",
  },
  ["<M-u>"] = {
    "<C-o>dg_",
    "i",
    desc = "Delete to the last non-blank character of the current line",
  },
  ["<C-space><C-u>"] = {
    "<C-o>d0",
    "i",
    desc = "Delete to the first character of the current line",
  },
  ["<M-space><M-u>"] = {
    "<C-o>d$",
    "i",
    desc = "Delete to the last character of the current line",
  },

  ["<C-Space><C-h>"] = {
    "<C-o>d^",
    "i",
    desc = "Delete to the first non-blank character of the current line",
  },
  ["<C-Space><C-l>"] = {
    "<C-o>dg_",
    "i",
    desc = "Delete to the end non-blank character of the current  line",
  },

  ["<C-Space><C-Space><C-h>"] = {
    "<C-o>d0",
    "i",
    desc = "Delete to the first character of the current line",
  },
  ["<C-Space><C-Space><C-l>"] = {
    "<C-o>d$",
    "i",
    desc = "Delete to the end character of the current line",
  },

  ["<C-S-Space><C-S-h>"] = {
    "<C-o>dg^",
    "i",
    desc = "Delete to the first non-blank character of the screen line",
  },
  ["<C-S-Space><C-S-l>"] = {
    "<C-o>dg<End>",
    "i",
    desc = "Delete to the end non-blank character of the screen line",
  },
  ["<C-S-Space><C-S-Space><C-S-h>"] = {
    "<C-o>dg0",
    "i",
    desc = "Delete to the first character of the screen line",
  },
  ["<C-S-Space><C-S-Space><C-S-l>"] = {
    "<C-o>dg$",
    "i",
    desc = "Delete to the end character of the screen line",
  },

  ["<C-M-u>"] = {
    "<C-G>u<C-u><C-o>d$",
    "i",
    desc = "Delete the current line",
  },
}
