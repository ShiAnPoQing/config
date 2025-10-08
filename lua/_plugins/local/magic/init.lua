local keys = {
  ["0k"] = {
    function()
      require("magic.magic-line").magic_line({
        dir = "up",
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.virt_col })
        end,
      })
    end,
    { "n", "x" },
  },
  ["0j"] = {
    function()
      require("magic.magic-line").magic_line({
        dir = "down",
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.virt_col })
        end,
      })
    end,
    { "n", "x" },
  },
  ["0o"] = {
    function()
      require("magic").magic_keyword({
        position = 2,
        keyword = function(builtin)
          return builtin.word_inner
        end,
        should_visual = false,
        callback = function(opts)
          -- 光标设置必须使用字节位置
          vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
        end,
      })
    end,
    "n",
  },
  ["0i"] = {
    function()
      require("magic").magic_keyword({
        position = 1,
        keyword = function(builtin)
          return builtin.word_inner
        end,
        should_visual = false,
        callback = function(opts)
          -- 光标设置必须使用字节位置
          vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
        end,
      })
    end,
    "n",
  },
  ["0O"] = {
    function()
      require("magic").magic_keyword({
        position = 2,
        keyword = function(builtin)
          return builtin.WORD_inner
        end,
        should_visual = false,
        callback = function(opts)
          -- 光标设置必须使用字节位置
          vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
        end,
      })
    end,
    "n",
  },
  ["0I"] = {
    function()
      require("magic").magic_keyword({
        position = 1,
        keyword = function(builtin)
          return builtin.WORD_inner
        end,
        should_visual = false,
        callback = function(opts)
          -- 光标设置必须使用字节位置
          vim.api.nvim_win_set_cursor(0, { opts.line + 1, opts.col })
        end,
      })
    end,
    "n",
  },
  ["0<space>h"] = {
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = false,
      })
    end,
    { "n", "x" },
  },
  ["0<space>l"] = {
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = false,
      })
    end,
    { "n", "x" },
  },
  ["0<space><space>h"] = {
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          print(opts.line, opts.col)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = true,
      })
    end,
    { "n", "x" },
  },
  ["0<space><space>l"] = {
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = true,
      })
    end,
    { "n", "x" },
  },
  ["0<space>w"] = {
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
          vim.api.nvim_feedkeys("i", "n", false)
        end,
        blank = false,
      })
    end,
    "n",
  },
  ["0<space>e"] = {
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
          vim.api.nvim_feedkeys("a", "n", false)
        end,
        blank = false,
      })
    end,
    "n",
  },
  ["0<space><space>w"] = {
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
          vim.api.nvim_feedkeys("i", "n", false)
        end,
        blank = true,
      })
    end,
    "n",
  },
  ["0<space><space>e"] = {
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
          vim.api.nvim_feedkeys("a", "n", false)
        end,
        blank = true,
      })
    end,
    "n",
  },
}

local delete_keys = require("_plugins.local.magic.delete")
local visual_keys = require("_plugins.local.magic.visual")
local yank_keys = require("_plugins.local.magic.yank")
local change_keys = require("_plugins.local.magic.change")
local upper_lower_keys = require("_plugins.local.magic.upper-lowercase")
local screen_keys = require("_plugins.local.magic.screen")
local move_line_keys = require("_plugins.local.magic.move-line")
local put_keys = require("_plugins.local.magic.put")
--
vim.list_extend(keys, delete_keys)
vim.list_extend(keys, visual_keys)
vim.list_extend(keys, yank_keys)
vim.list_extend(keys, change_keys)
vim.list_extend(keys, upper_lower_keys)
vim.list_extend(keys, screen_keys)
vim.list_extend(keys, move_line_keys)
vim.list_extend(keys, put_keys)

return {
  name = "magic",
  keys = keys,
  config = function()
    require("magic").setup()
  end,
}
