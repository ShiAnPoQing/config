return {
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
}
