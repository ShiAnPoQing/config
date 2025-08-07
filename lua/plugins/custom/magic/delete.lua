return {
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
}
