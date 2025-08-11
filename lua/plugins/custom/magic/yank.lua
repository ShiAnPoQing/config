local function yank(opts)
  local line = opts.line
  local start_col = opts.start_col
  local end_col = opts.end_col
  vim.fn.setreg("+", vim.api.nvim_buf_get_text(0, line, start_col, line, end_col, {})[1])
end

local function magic_yank_keyword(keyword)
  require("magic").magic_keyword({
    position = 3,
    keyword = keyword,
    should_visual = true,
    callback = yank,
  })
end

local function yank_to(opts)
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  if opts.position == 1 then
    require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line + 1, opts.col - 1)
    vim.api.nvim_feedkeys("gvy", "n", false)
  else
    require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line + 1, opts.col)
    vim.api.nvim_feedkeys("gvy", "n", false)
  end
end

local function magic_yank_to_keyword(position, keyword)
  require("magic").magic_keyword({
    position = position,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      yank_to(vim.tbl_extend("force", { position = position }, opts))
    end,
  })
end

return {
  {
    "0ywi",
    function()
      magic_yank_keyword(function(builtin)
        return builtin.word_inner
      end)
    end,
  },
  {
    "0ywo",
    function()
      magic_yank_keyword(function(builtin)
        return builtin.word_outer
      end)
    end,
  },
  {
    "0yWi",
    function()
      magic_yank_keyword(function(builtin)
        return builtin.WORD_inner
      end)
    end,
  },
  {
    "0yWo",
    function()
      magic_yank_keyword(function(builtin)
        return builtin.WORD_outer
      end)
    end,
  },
  {
    "0yr",
    function()
      vim.ui.input({ prompt = ">复制>正则匹配: " }, function(input)
        magic_yank_keyword(input)
      end)
    end,
  },
  {
    "y0o",
    function()
      magic_yank_to_keyword(2, function(builtin)
        return builtin.word_inner
      end)
    end,
  },
  {
    "y0i",
    function()
      magic_yank_to_keyword(1, function(builtin)
        return builtin.word_inner
      end)
    end,
  },
  {
    "y0<space>h",
    function()
      require("custom.plugins.magic").magic_yank_to_line_start_end({
        position = 1,
      })
    end,
  },
  {
    "y0<space>l",
    function()
      require("custom.plugins.magic").magic_yank_to_line_start_end({
        position = 2,
      })
    end,
  },
}
