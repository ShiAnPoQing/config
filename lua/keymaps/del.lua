local function ctrl_space_ctrl_i()
  vim.cmd.stopinsert()
  vim.schedule(function()
    local end_pos = vim.api.nvim_win_get_cursor(0)
    local end_row = end_pos[1]
    local end_col = end_pos[2]
    vim.api.nvim_exec2([[
    exec "normal! ge"
    ]], {})
    local start_pos = vim.api.nvim_win_get_cursor(0)
    local start_row = start_pos[1]
    local start_col = start_pos[2]

    if end_col == start_col then
      vim.api.nvim_feedkeys("a", "n", false)
      return
    end
    if start_col == 0 then
      vim.api.nvim_buf_set_text(0, start_row - 1, 0, start_row - 1, end_col + 1, { "" })
    else
      vim.api.nvim_buf_set_text(0, start_row - 1, start_col + 1, end_row - 1, end_col + 1, { "" })
    end
    vim.api.nvim_feedkeys("a", "n", false)
  end)
end

return {
  ["<S-BS>"] = { "<Del>", { "i" } },
  ["<C-BS>"] = { "<Left><C-o>diw", { "i" } },
  ["<M-BS>"] = { "<C-o>diw", { "i" } },
  ["<C-i>"] = { "<Esc>ldbi", "i", { noremap = true } },
  ["<C-o>"] = { "<C-o>de", "i", { noremap = true } },
  ["<C-S-i>"] = { "<C-o>dB", "i", { noremap = true } },
  ["<C-S-o>"] = { "<C-o>dE", "i", { noremap = true } },
  ["<C-Space><C-i>"] = { ctrl_space_ctrl_i, "i", { noremap = true } },
  ["<C-Space><C-o>"] = { "<C-o>dw", "i", { noremap = true } },
  ["<C-Space><C-S-O>"] = { "<C-o>dW", "i", { noremap = true } },
  ["<C-Space><C-S-i>"] = { "<C-o>dgE", "i" },
  -- del cursor left all text
  ["<C-u>"] = { "<C-G>u<C-u>", { "i" } },
  -- del cursor right all text
  ["<M-u>"] = { "<C-o>d$", { "i" } },
  ["<C-M-u>"] = { "<C-G>u<C-u><C-o>d$", "i" },
  -- del cursor left all text(without space)
  ["<C-space><C-u>"] = { "<C-o>d^", { "i" } },
  -- del cursor right all text(without space)
  ["<M-space><M-u>"] = { "<C-o>v$ged", { "i" } },

  ["<C-Space><C-h>"] = { "<C-o>d^", "i", { noremap = true } },
  ["<C-Space><C-l>"] = { "<C-o>dg_", "i", { noremap = true } }
}
