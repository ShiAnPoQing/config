local M = {}
local magic_keyword = require("custom.plugins.magic.magic-keyword")
local magic_word_edge = require("custom.plugins.magic.magic-word-edge")
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
    callback = function(line, start_col, end_col)
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gv", "n", true)
    end,
  })
end

function M.magic_yank_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(line, start_col, end_col)
      vim.fn.setreg("+", vim.api.nvim_buf_get_text(0, line, start_col, line, end_col, {})[1])
    end,
  })
end

function M.magic_delete_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(line, start_col, end_col)
      vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
    end,
  })
end

function M.magic_change_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(line, start_col, end_col)
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gvc", "n", true)
    end,
  })
end

function M.magic_uppercase_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(line, start_col, end_col)
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gvU", "n", true)
    end,
  })
end

function M.magic_lowercase_keyword(opt)
  magic_keyword.magic_keyword({
    keyword = opt.keyword,
    callback = function(line, start_col, end_col)
      require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
      vim.api.nvim_feedkeys("gvu", "n", true)
    end,
  })
end

function M.magic_delete_to_word(opt)
  magic_word_edge.magic_word_edge({
    type = opt.type,
    position = opt.position,
    callback = function(opts)
      require("utils.mark").set_visual_mark(opts.cursor[1], opts.cursor[2], opts.line + 1, opts.col)
      vim.api.nvim_feedkeys("gvd", "n", false)
    end,
  })
end

function M.magic_delete_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line, opts.col)
      vim.api.nvim_feedkeys("gvd", "n", false)
    end,
  })
end

function M.magic_change_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
      require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line, opts.col)
      vim.api.nvim_feedkeys("gvc", "n", false)
    end,
  })
end

function M.magic_yank_to_line_start_end(opts)
  magic_line_start_end.magic_line_start_end({
    position = opts.position,
    callback = function(opts)
      local cursor = vim.api.nvim_win_get_cursor(0)
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

function M.setup()
  set_hl_group()
end

return M
