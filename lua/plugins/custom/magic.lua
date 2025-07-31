return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/magic",
  name = "magic",
  keys = {
    {
      "0vwi",
      function()
        require("custom.plugins.magic").magic_visual_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0vwo",
      function()
        require("custom.plugins.magic").magic_visual_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0vWi",
      function()
        require("custom.plugins.magic").magic_visual_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0vWo",
      function()
        require("custom.plugins.magic").magic_visual_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },
    {
      "0ywi",
      function()
        require("custom.plugins.magic").magic_yank_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0ywo",
      function()
        require("custom.plugins.magic").magic_yank_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0yWi",
      function()
        require("custom.plugins.magic").magic_yank_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0yWo",
      function()
        require("custom.plugins.magic").magic_yank_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },

    {
      "0dwi",
      function()
        require("custom.plugins.magic").magic_delete_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0dwo",
      function()
        require("custom.plugins.magic").magic_delete_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0dWi",
      function()
        require("custom.plugins.magic").magic_delete_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0dWo",
      function()
        require("custom.plugins.magic").magic_delete_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },
    {
      "0cwi",
      function()
        require("custom.plugins.magic").magic_change_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0cwo",
      function()
        require("custom.plugins.magic").magic_change_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0cWi",
      function()
        require("custom.plugins.magic").magic_change_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0cWo",
      function()
        require("custom.plugins.magic").magic_change_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },
    {
      "0gUwi",
      function()
        require("custom.plugins.magic").magic_uppercase_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0gUwo",
      function()
        require("custom.plugins.magic").magic_uppercase_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0gUWi",
      function()
        require("custom.plugins.magic").magic_uppercase_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0gUwo",
      function()
        require("custom.plugins.magic").magic_uppercase_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },
    {
      "0guwi",
      function()
        require("custom.plugins.magic").magic_lowercase_keyword({
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "0guwo",
      function()
        require("custom.plugins.magic").magic_lowercase_keyword({
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
    },
    {
      "0guWi",
      function()
        require("custom.plugins.magic").magic_lowercase_keyword({
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
    },
    {
      "0guwo",
      function()
        require("custom.plugins.magic").magic_lowercase_keyword({
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
    },
    {
      "0cr",
      function()
        vim.ui.input({ prompt = ">修改>正则匹配: " }, function(input)
          require("custom.plugins.magic").magic_change_keyword({
            keyword = input,
          })
        end)
      end,
    },
    {
      "0dr",
      function()
        vim.ui.input({ prompt = ">删除>正则匹配: " }, function(input)
          require("custom.plugins.magic").magic_delete_keyword({
            keyword = input,
          })
        end)
      end,
    },
    {
      "0vr",
      function()
        vim.ui.input({ prompt = ">选中>正则匹配: " }, function(input)
          require("custom.plugins.magic").magic_visual_keyword({
            keyword = input,
          })
        end)
      end,
    },
    {
      "0yr",
      function()
        vim.ui.input({ prompt = ">复制>正则匹配: " }, function(input)
          require("custom.plugins.magic").magic_yank_keyword({
            keyword = input,
          })
        end)
      end,
    },
    {
      "0k",
      function()
        require("custom.plugins.magic.magic-line-move").magic_line_move("up")
      end,
      mode = { "n", "x" },
    },
    {
      "0j",
      function()
        require("custom.plugins.magic.magic-line-move").magic_line_move("down")
      end,
      mode = { "n", "x" },
    },
    {
      "0o",
      function()
        require("custom.plugins.magic").magic_word_move({
          position = 2,
          keyword = function(opts)
            return opts.word_outer
          end,
        })
      end,
      mode = { "n", "x" },
    },
    {
      "0i",
      function()
        require("custom.plugins.magic").magic_word_move({
          position = 1,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
      mode = { "n", "x" },
    },
    {
      "0O",
      function()
        require("custom.plugins.magic").magic_word_move({
          position = 2,
          keyword = function(opts)
            return opts.WORD_outer
          end,
        })
      end,
      mode = { "n", "x" },
    },
    {
      "0I",
      function()
        require("custom.plugins.magic").magic_word_move({
          position = 1,
          keyword = function(opts)
            return opts.WORD_inner
          end,
        })
      end,
      mode = { "n", "x" },
    },
    {
      "0<space>h",
      function()
        require("custom.plugins.magic").magic_line_start_end_move({ position = 1 })
      end,
      mode = { "n", "x" },
    },
    {
      "0<space>l",
      function()
        require("custom.plugins.magic").magic_line_start_end_move({ position = 2 })
      end,
      mode = { "n", "x" },
    },
    {
      "d0o",
      function()
        require("custom.plugins.magic").magic_delete_to_keyword({
          position = 2,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "d0i",
      function()
        require("custom.plugins.magic").magic_delete_to_keyword({
          position = 1,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "y0o",
      function()
        require("custom.plugins.magic").magic_yank_to_keyword({
          position = 2,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "y0i",
      function()
        require("custom.plugins.magic").magic_yank_to_keyword({
          position = 1,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "c0o",
      function()
        require("custom.plugins.magic").magic_change_to_keyword({
          position = 2,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "c0i",
      function()
        require("custom.plugins.magic").magic_change_to_keyword({
          position = 1,
          keyword = function(opts)
            return opts.word_inner
          end,
        })
      end,
    },
    {
      "d0<space>l",
      function()
        require("custom.plugins.magic").magic_delete_to_line_start_end({
          position = 2,
        })
      end,
    },
    {
      "d0<space>h",
      function()
        require("custom.plugins.magic").magic_delete_to_line_start_end({
          position = 1,
        })
      end,
    },
    {
      "c0<space>h",
      function()
        require("custom.plugins.magic").magic_change_to_line_start_end({
          position = 1,
        })
      end,
    },
    {
      "c0<space>l",
      function()
        require("custom.plugins.magic").magic_change_to_line_start_end({
          position = 2,
        })
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
  },
  config = function(opt)
    require("custom.plugins.magic").setup()
  end,
}
