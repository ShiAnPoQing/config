return {
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
