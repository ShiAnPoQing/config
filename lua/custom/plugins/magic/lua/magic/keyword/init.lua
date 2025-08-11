local M = {
  --- @class KeywordMainOpts: KeywordOpts
  --- @field register_key fun(match_opts)
  --- @field end_callback fun()

  --- @param opts KeywordMainOpts
  main = function(opts)
    local keyword = require("magic.keyword.keyword")
    keyword:init(opts)
    keyword:match()
    keyword:match_foreach(opts.register_key)
    keyword:clean()
    opts.end_callback()
  end,
}

return M
