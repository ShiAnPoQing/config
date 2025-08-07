local M = {}
local magic_keyword = require("custom.plugins.magic.magic-keyword")
local magic_line_start_end = require("custom.plugins.magic.magic-line-start-end")

local function set_hl_group()
  local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })

  vim.api.nvim_set_hl(0, "CustomMagicNextKey", {
    fg = "#ff007c",
  })
  vim.api.nvim_set_hl(0, "CustomMagicNextKey1", {
    fg = "#00dfff",
  })
  vim.api.nvim_set_hl(0, "CustomMagicNextKey2", {
    fg = "#2b8db3",
  })
  vim.api.nvim_set_hl(0, "CustomMagicUnmatched", {
    fg = "#666666",
  })
  vim.api.nvim_set_hl(0, "CustomMagicNextKeyInVisual", {
    fg = "#ff007c",
    bg = visual_hl.bg,
  })
  vim.api.nvim_set_hl(0, "CustomMagicNextKey1InVisual", {
    fg = "#00dfff",
    bg = visual_hl.bg,
  })
  vim.api.nvim_set_hl(0, "CustomMagicNextKey2InVisual", {
    fg = "#2b8db3",
    bg = visual_hl.bg,
  })
end

function M.magic_visual_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(opts.line + 1, opts.start_col, opts.line + 1, opts.end_col - 1)
      vim.api.nvim_feedkeys("gv", "n", true)
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_yank_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      local line = opts.line
      local start_col = opts.start_col
      local end_col = opts.end_col
      vim.fn.setreg("+", vim.api.nvim_buf_get_text(0, line, start_col, line, end_col, {})[1])
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_delete_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      local line = opts.line
      local start_col = opts.start_col
      local end_col = opts.end_col
      vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_change_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(opts.line + 1, opts.start_col, opts.line + 1, opts.end_col - 1)
      vim.cmd("normal! gvc")
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_uppercase_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      local line = opts.line
      local start_col = opts.start_col
      local end_col = opts.end_col
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gvU", "n", true)
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_lowercase_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(opts)
      local line = opts.line
      local start_col = opts.start_col
      local end_col = opts.end_col
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gvu", "n", true)
    end,
    key_position = 1,
    should_visual = true,
  })
end

function M.magic_delete_to_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(callback_opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], callback_opts.line, callback_opts.col + 1, {})
    end,
    key_position = opt.position,
    should_visual = false,
  })
end

function M.magic_yank_to_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(callback_opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      if opt.position == 1 then
        require("utils.mark").set_visual_mark(cursor[1], cursor[2], callback_opts.line + 1, callback_opts.col - 1)
        vim.api.nvim_feedkeys("gvy", "n", false)
      else
        require("utils.mark").set_visual_mark(cursor[1], cursor[2], callback_opts.line + 1, callback_opts.col)
        vim.api.nvim_feedkeys("gvy", "n", false)
      end
    end,
    key_position = opt.position,
    should_visual = false,
  })
end

function M.magic_change_to_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(callback_opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], callback_opts.line + 1 - 1, callback_opts.col + 1, {})
      vim.api.nvim_feedkeys("i", "n", false)
    end,
    key_position = opt.position,
    should_visual = false,
  })
end

function M.magic_delete_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(callback_opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      local start_row
      local start_col
      local end_row
      local end_col
      if cursor[1] >= callback_opts.line then
        start_row = callback_opts.line - 1
        start_col = callback_opts.col + 1
        end_row = cursor[1] - 1
        end_col = cursor[2]
      else
        end_row = callback_opts.line - 1
        end_col = callback_opts.col + 1
        start_row = cursor[1] - 1
        start_col = cursor[2]
      end
      vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {})
    end,
  })
end

function M.magic_change_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line, opts.col)
      vim.api.nvim_feedkeys("gv", "n", false)
    end,
  })
end

function M.magic_yank_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Fix the visual mode (防止 gv 进入 visual line mode)
      vim.cmd("normal! vv")
      require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line, opts.col)
      vim.api.nvim_feedkeys("gvy", "n", false)
    end,
  })
end

function M.magic_line_start_end_move(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
    end,
  })
end

function M.magic_word_move(opts)
  magic_keyword.magic_keyword({
    keyword = opts.keyword,
    callback = function(opts)
      -- 光标设置必须使用字节位置
      vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
    end,
    key_position = opts.position,
    should_visual = false,
  })
end

function M.setup()
  set_hl_group()
end

return M
