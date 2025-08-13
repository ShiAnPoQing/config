return {
  {
    "<leader>gg",
    function()
      require("fzf-lua").grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>gw",
    function()
      require("fzf-lua").grep_cword()
    end,
    desc = "Grep cword",
  },
  {
    "<leader>gW",
    function()
      require("fzf-lua").grep_cWORD()
    end,
    desc = "Grep CWORD",
  },
  {
    "<leader>gv",
    function()
      require("fzf-lua").grep_visual()
    end,
    desc = "Grep Visual",
    mode = "x",
  },
  {
    "<leader>gp",
    function()
      require("fzf-lua").grep_project()
    end,
    desc = "Grep Project Line",
  },
  {
    "<leader>gb",
    function()
      require("fzf-lua").grep_curbuf()
    end,
    desc = "Grep Current Buffer Line",
  },
  {
    "<leader>gq",
    function()
      require("fzf-lua").grep_quickfix()
    end,
    desc = "Grep Quickfix",
  },
  {
    "<leader>gl",
    function()
      require("fzf-lua").grep({ resume = true })
    end,
    desc = "Grep Last",
  },
  {
    "<leader>gj",
    function()
      require("fzf-lua").grep_loclist()
    end,
    desc = "Grep Loclist",
  },
}
