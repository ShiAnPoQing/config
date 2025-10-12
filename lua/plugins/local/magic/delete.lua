local function delete(opts)
  local line = opts.line
  local start_col = opts.start_col
  local end_col = opts.end_col
  vim.api.nvim_buf_set_text(0, line, start_col, line, end_col, {})
end

local function magic_delete_keyword(keyword)
  require("magic").magic_keyword({
    position = 3,
    keyword = keyword,
    should_visual = true,
    callback = delete,
  })
end

local function delete_to(opts)
  local cursor = vim.api.nvim_win_get_cursor(0)
  if opts.position == 1 then
    vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], opts.line, opts.col + 1 - 1, {})
  elseif opts.position == 2 then
    vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], opts.line, opts.col + 1, {})
  end
end

local function magic_delete_to_keyword(position, keyword)
  require("magic").magic_keyword({
    position = position,
    keyword = keyword,
    should_visual = true,
    callback = function(opts)
      delete_to(vim.tbl_extend("force", { position = position }, opts))
    end,
  })
end

return {
  ["0dwi"] = {
    function()
      magic_delete_keyword(function(opts)
        return opts.word_inner
      end)
    end,
    "n",
  },
  ["0dwo"] = {
    function()
      magic_delete_keyword(function(opts)
        return opts.word_outer
      end)
    end,
    "n",
  },
  ["0dWi"] = {
    function()
      magic_delete_keyword(function(opts)
        return opts.WORD_inner
      end)
    end,
    "n",
  },
  ["0dWo"] = {
    function()
      magic_delete_keyword(function(opts)
        return opts.WORD_outer
      end)
    end,
    "n",
  },
  ["0dr"] = {
    function()
      vim.ui.input({ prompt = ">删除>正则匹配: " }, function(input)
        magic_delete_keyword(input)
      end)
    end,
    "n",
  },
  ["d0o"] = {
    function()
      magic_delete_to_keyword(2, function(opts)
        return opts.word_inner
      end)
    end,
    "n",
  },
  ["d0i"] = {
    function()
      magic_delete_to_keyword(1, function(opts)
        return opts.word_inner
      end)
    end,
    "n",
  },
  -- {
  --   "d0<space>l",
  --   function()
  --     require("custom.plugins.magic").magic_delete_to_line_start_end({
  --       position = 2,
  --     })
  --   end,
  -- },
  -- {
  --   "d0<space>h",
  --   function()
  --     require("custom.plugins.magic").magic_delete_to_line_start_end({
  --       position = 1,
  --     })
  --   end,
  -- },
}
