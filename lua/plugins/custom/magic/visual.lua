local function visual(opts)
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  require("utils.mark").set_visual_mark(opts.line + 1, opts.start_col, opts.line + 1, opts.end_col - 1)
  vim.api.nvim_feedkeys("gv", "n", true)
end

local function magic_visual_keyword(keyword)
  require("magic").magic_keyword({
    position = 3,
    keyword = keyword,
    should_visual = true,
    callback = visual,
  })
end

local function visual_to(opts)
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Fix the visual mode (防止 gv 进入 visual line mode)
  vim.cmd("normal! vv")
  if opts.position == 1 then
    require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line + 1, opts.col - 1)
    vim.api.nvim_feedkeys("gv", "n", false)
  else
    require("utils.mark").set_visual_mark(cursor[1], cursor[2], opts.line + 1, opts.col)
    vim.api.nvim_feedkeys("gv", "n", false)
  end
end

local function magic_visual_to_keyword(position, keyword)
  require("magic").magic_keyword({
    position = position,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      visual_to(vim.tbl_extend("force", { position = position }, opts))
    end,
  })
end

return {
  {
    "0vw(",
    function()
      require("magic").magic_keyword({
        position = 3,
        keyword = "([^)]*)",
        should_visual = true,
        should_capture = true,
        callback = function(opts)
          -- -- 光标设置必须使用字节位置
          -- vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
        end,
      })
    end,
  },
  -- {
  --   "0vw)",
  --   function()
  --     require("custom.plugins.magic").magic_visual_keyword({
  --       keyword = "([^)]*)",
  --     })
  --   end,
  -- },
  -- {
  --   "0vw{",
  --   function()
  --     require("custom.plugins.magic").magic_visual_keyword({
  --       keyword = "{[^}]*}",
  --     })
  --   end,
  -- },
  -- {
  --   "0vw}",
  --   function()
  --     require("custom.plugins.magic").magic_visual_keyword({
  --       keyword = "{[^}]*}",
  --     })
  --   end,
  -- },
  {
    "0vwi",
    function()
      magic_visual_keyword(function(builtin)
        return builtin.word_inner
      end)
    end,
  },
  {
    "0vwo",
    function()
      magic_visual_keyword(function(builtin)
        return builtin.word_outer
      end)
    end,
  },
  {
    "0vWi",
    function()
      magic_visual_keyword(function(builtin)
        return builtin.WORD_inner
      end)
    end,
  },
  {
    "0vWo",
    function()
      magic_visual_keyword(function(builtin)
        return builtin.WORD_outer
      end)
    end,
  },
  {
    "0vr",
    function()
      vim.ui.input({ prompt = ">选中>正则匹配: " }, function(input)
        magic_visual_keyword(input)
      end)
    end,
  },

  {
    "v0o",
    function()
      magic_visual_to_keyword(2, function(builtin)
        return builtin.word_inner
      end)
    end,
  },
  {
    "v0i",
    function()
      magic_visual_to_keyword(1, function(builtin)
        return builtin.word_inner
      end)
    end,
  },
}
