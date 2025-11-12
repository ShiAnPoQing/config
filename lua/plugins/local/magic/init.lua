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
  -- ["0<space>h"] = {
  --   function()
  --     require("magic").magic_line_start_end({
  --       position = 1,
  --       callback = function(opts)
  --         vim.api.nvim_win_set_cursor(0, { opts.line, opts.col })
  --       end,
  --       blank = false,
  --     })
  --   end,
  --   { "n", "x" },
  -- },
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

local delete_keys = require("plugins.local.magic.delete")
local visual_keys = require("plugins.local.magic.visual")
local yank_keys = require("plugins.local.magic.yank")
local change_keys = require("plugins.local.magic.change")
local upper_lower_keys = require("plugins.local.magic.upper-lowercase")
local screen_keys = require("plugins.local.magic.screen")
local move_line_keys = require("plugins.local.magic.move-line")
local put_keys = require("plugins.local.magic.put")

local function merge(sources)
  for _, source in ipairs(sources) do
    for k, v in pairs(source) do
      keys[k] = v
    end
  end
end
-- merge({ delete_keys, visual_keys, yank_keys, change_keys, upper_lower_keys, screen_keys, move_line_keys, put_keys })

return {
  name = "magic",
  keys = keys,
  config = function()
    require("magic").setup()
  end,
}
