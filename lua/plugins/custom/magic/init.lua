local keys = {
  {
    "0k",
    function()
      require("magic.magic-line").magic_line("up")
    end,
    mode = { "n", "x" },
  },
  {
    "0j",
    function()
      require("magic.magic-line").magic_line("down")
    end,
    mode = { "n", "x" },
  },
  {
    "0o",
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
  },
  {
    "0i",
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
  },
  {
    "0O",
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
  },
  {
    "0I",
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
  },
  {
    "0<space>h",
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = false,
      })
    end,
    mode = { "n", "x" },
  },
  {
    "0<space>l",
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = false,
      })
    end,
    mode = { "n", "x" },
  },
  {
    "0<space><space>h",
    function()
      require("magic").magic_line_start_end({
        position = 1,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = true,
      })
    end,
    mode = { "n", "x" },
  },
  {
    "0<space><space>l",
    function()
      require("magic").magic_line_start_end({
        position = 2,
        callback = function(opts)
          vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
        end,
        blank = true,
      })
    end,
    mode = { "n", "x" },
  },
}

local delete_keys = require("plugins.custom.magic.delete")
local visual_keys = require("plugins.custom.magic.visual")
local yank_keys = require("plugins.custom.magic.yank")
local change_keys = require("plugins.custom.magic.change")
local upper_lower_keys = require("plugins.custom.magic.upper-lowercase")
local screen_keys = require("plugins.custom.magic.screen")
local move_line_keys = require("plugins.custom.magic.move-line")

vim.list_extend(keys, delete_keys)
vim.list_extend(keys, visual_keys)
vim.list_extend(keys, yank_keys)
vim.list_extend(keys, change_keys)
vim.list_extend(keys, upper_lower_keys)
vim.list_extend(keys, screen_keys)
vim.list_extend(keys, move_line_keys)

return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/magic",
  name = "magic",
  keys = keys,
  config = function(opt)
    require("magic").setup()
  end,
}
