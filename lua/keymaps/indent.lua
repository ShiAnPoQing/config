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

return {
  ["<C-.>"] = { "<C-T>", "i", desc = "Insert one shiftwidth of indent at the start of the current line" },
  ["<C-,>"] = { "<C-D>", "i", desc = "Delete one shiftwidth of indent at the start of the current line" },
  -- ["<C-space><C-,>"] = { "0<C-D>", "i", desc = "Delete all indent in the current line" },
  ["<C-space><C-,>"] = { "^<C-D>", "i", desc = "Delete all indent in the current line" },
  ["<C-space><C-.>"] = { "^<C-D>", "i", desc = "Delete all indent in the current line" },
  ["<space><"] = {
    function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", true)
      local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
      local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
      local min_indent

      for _, line in ipairs(lines) do
        local indent = line:find("[^%s]")
        if not min_indent then
          min_indent = indent
        else
          if indent and indent < min_indent then
            min_indent = indent
          end
        end
      end

      if not min_indent then
        return
      end

      local new_lines = {}

      for i, line in ipairs(lines) do
        new_lines[i] = line:sub(min_indent)
      end
      vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, new_lines)
      vim.api.nvim_buf_set_mark(0, "<", start_row, start_col, {})
      vim.api.nvim_buf_set_mark(0, ">", end_row, end_col, {})
    end,
    "x",
    desc = "Delete All Indext",
  },
}
