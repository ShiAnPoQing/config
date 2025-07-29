local M = {}

function M.set_window_size(opts)
  if opts.width ~= nil then
    vim.api.nvim_win_set_width(opts.win_id, opts.width)
  end

  if opts.height ~= nil then
    vim.api.nvim_win_set_height(opts.win_id, opts.height)
  end
end

return M
