local function switch_case(opts, operator)
  local line = opts.line
  local start_col = opts.start_col
  local end_col = opts.end_col
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
  vim.api.nvim_feedkeys("gv" .. operator, "n", true)
end

local function magic_switch_case_keyword(keyword, operator)
  require("magic").magic_keyword({
    position = 3,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      switch_case(opts, operator)
    end,
  })
end

local function switch_case_to(opts, operator)
  local line = opts.line
  local start_col = opts.start_col
  local end_col = opts.end_col
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  if opts.position == 1 then
    require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
  elseif opts.position == 2 then
    require("utils.mark").set_visual_mark(line + 1, start_col, line + 1, end_col - 1)
  end

  vim.api.nvim_feedkeys("gv" .. operator, "n", true)
end

local function magic_switch_case_to_keyword(position, keyword, operator)
  require("magic").magic_keyword({
    position = position,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      switch_case_to(vim.tbl_extend("force", { position = position }, opts), operator)
    end,
  })
end

return {
  {
    "0gUwi",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.word_inner
      end, "U")
    end,
  },
  {
    "0gUwo",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.word_outer
      end, "U")
    end,
  },
  {
    "0gUWi",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.WORD_inner
      end, "U")
    end,
  },
  {
    "0gUwo",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.WORD_outer
      end, "U")
    end,
  },
  {
    "0guwi",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.word_inner
      end, "u")
    end,
  },
  {
    "0guwo",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.word_outer
      end, "u")
    end,
  },
  {
    "0guWi",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.WORD_inner
      end, "u")
    end,
  },
  {
    "0guwo",
    function()
      magic_switch_case_keyword(function(opts)
        return opts.WORD_outer
      end, "u")
    end,
  },
  {
    "gU0i",
    function()
      magic_switch_case_to_keyword(1, function(opts)
        return opts.word_inner
      end, "U")
    end,
  },
  {
    "gU0o",
    function()
      magic_switch_case_to_keyword(2, function(opts)
        return opts.word_inner
      end, "U")
    end,
  },
  {
    "gU0I",
    function()
      magic_switch_case_to_keyword(1, function(opts)
        return opts.WORD_inner
      end, "U")
    end,
  },
  {
    "gU0O",
    function()
      magic_switch_case_to_keyword(2, function(opts)
        return opts.WORD_inner
      end, "U")
    end,
  },
  {
    "gu0i",
    function()
      magic_switch_case_to_keyword(1, function(opts)
        return opts.word_inner
      end, "u")
    end,
  },
  {
    "gu0o",
    function()
      magic_switch_case_to_keyword(2, function(opts)
        return opts.word_inner
      end, "u")
    end,
  },
  {
    "gu0I",
    function()
      magic_switch_case_to_keyword(1, function(opts)
        return opts.WORD_inner
      end, "u")
    end,
  },
  {
    "gu0O",
    function()
      magic_switch_case_to_keyword(2, function(opts)
        return opts.WORD_inner
      end, "u")
    end,
  },
}
