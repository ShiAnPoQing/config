return {
  {
    "0vw(",
    function()
      require("custom.plugins.magic").magic_visual_keyword({
        keyword = "([^)]*)",
      })
    end,
  },
  {
    "0vw)",
    function()
      require("custom.plugins.magic").magic_visual_keyword({
        keyword = "([^)]*)",
      })
    end,
  },
  {
    "0vw{",
    function()
      require("custom.plugins.magic").magic_visual_keyword({
        keyword = "{[^}]*}",
      })
    end,
  },
  {
    "0vw}",
    function()
      require("custom.plugins.magic").magic_visual_keyword({
        keyword = "{[^}]*}",
      })
    end,
  },
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
    "0vr",
    function()
      vim.ui.input({ prompt = ">选中>正则匹配: " }, function(input)
        require("custom.plugins.magic").magic_visual_keyword({
          keyword = input,
        })
      end)
    end,
  },
}
