return {
  {
    "<leader>lgg",
    function()
      require("fzf-lua").live_grep()
    end,
    desc = "Live Grep",
  },
  {
    "<leader>lgr",
    function()
      require("fzf-lua").live_grep_resume()
    end,
    desc = "Live Grep Resume",
  },
  {
    "<leader>lgn",
    function()
      require("fzf-lua").live_grep_native()
    end,
    desc = "Live Grep Native",
  },
  {
    "<leader>lgq",
    function()
      require("fzf-lua").lgrep_quickfix()
    end,
    desc = "Live Grep Quickfix",
  },
  {
    "<leader>lgl",
    function()
      require("fzf-lua").lgrep_loclist()
    end,
    desc = "Live Grep Localist",
  },
  {
    "<leader>lgb",
    function()
      require("fzf-lua").lgrep_curbuf()
    end,
    desc = "Live Grep Current Buffer",
  },
}
