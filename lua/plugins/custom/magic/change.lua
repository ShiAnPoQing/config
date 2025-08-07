return {
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
}
