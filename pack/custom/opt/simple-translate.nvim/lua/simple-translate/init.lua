local M = {}

function M.translate(content, callback)
  vim.system({
    "trans",
    content,
  }, { text = true }, function(out)
    callback(out.stdout or "")
  end)
end

function M.visual_translate(opt)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", true)
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local texts = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})

  local text = ""

  for _, value in ipairs(texts) do
    text = text .. "\n" .. value
  end

  M.translate(text, function(re)
    vim.schedule(function()
      local lines = vim.split(re, "\n")
      table.remove(lines, #lines)
      vim.api.nvim_buf_set_lines(0, end_row, end_row, false, lines)
    end)
  end)
end

return M
