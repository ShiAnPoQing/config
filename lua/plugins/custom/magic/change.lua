local function change(opts)
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  require("utils.mark").set_visual_mark(opts.line + 1, opts.start_col, opts.line + 1, opts.end_col - 1)
  vim.cmd("normal! gvc")
end

local function magic_change_keyword(keyword)
  require("magic").magic_keyword({
    position = 3,
    keyword = keyword,
    should_visual = true,
    callback = change,
  })
end

local function change_to(opts)
  local cursor = vim.api.nvim_win_get_cursor(0)
  if opts.position == 1 then
    vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], opts.line + 1 - 1, opts.col + 1 - 1, {})
  elseif opts.position == 2 then
    vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], opts.line + 1 - 1, opts.col + 1, {})
  end
  vim.api.nvim_feedkeys("i", "n", false)
end

local function magic_change_to_keyword(position, keyword)
  require("magic").magic_keyword({
    position = position,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      change_to(vim.tbl_extend("force", { position = position }, opts))
    end,
  })
end

return {
  {
    "0cwi",
    function()
      magic_change_keyword(function(opts)
        return opts.word_inner
      end)
    end,
  },
  {
    "0cwo",
    function()
      magic_change_keyword(function(opts)
        return opts.word_outer
      end)
    end,
  },
  {
    "0cWi",
    function()
      magic_change_keyword(function(opts)
        return opts.WORD_inner
      end)
    end,
  },
  {
    "0cWo",
    function()
      magic_change_keyword(function(opts)
        return opts.WORD_outer
      end)
    end,
  },
  {
    "0cr",
    function()
      vim.ui.input({ prompt = ">修改>正则匹配: " }, function(input)
        magic_change_keyword(input)
      end)
    end,
  },
  {
    "c0o",
    function()
      magic_change_to_keyword(2, function(opts)
        return opts.word_inner
      end)
    end,
  },
  {
    "c0i",
    function()
      magic_change_to_keyword(1, function(opts)
        return opts.word_inner
      end)
    end,
  },
  {
    "c0O",
    function()
      magic_change_to_keyword(2, function(opts)
        return opts.WORD_inner
      end)
    end,
  },
  {
    "c0I",
    function()
      magic_change_to_keyword(1, function(opts)
        return opts.WORD_inner
      end)
    end,
  },
  -- {
  --   "c0<space>h",
  --   function()
  --     require("custom.plugins.magic").magic_change_to_line_start_end({
  --       position = 1,
  --     })
  --   end,
  -- },
  -- {
  --   "c0<space>l",
  --   function()
  --     require("custom.plugins.magic").magic_change_to_line_start_end({
  --       position = 2,
  --     })
  --   end,
  -- },
}
