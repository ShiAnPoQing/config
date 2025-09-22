return {
  {
    "<leader>tt",
    function()
      -- require("fzf-lua").tags({ cwd = vim.fn.fnamemodify(vim.fn.tagfiles()[1], ":p:h") })
      require("fzf-lua").tags()
    end,
    desc = "Tags",
  },
  {
    "<leader>tb",
    function()
      require("fzf-lua").btags()
    end,
    desc = "Buffer Tags",
  },
  {
    "<leader>tgg",
    function()
      require("fzf-lua").tags_grep()
    end,
    desc = "Tags Grep",
  },
  {
    "<leader>tgw",
    function()
      require("fzf-lua").tags_grep_cword()
    end,
    desc = "Tags Grep Cword",
  },
  {
    "<leader>tgW",
    function()
      require("fzf-lua").tags_grep_cWORD()
    end,
    desc = "Tags Grep CWORD",
  },
  {
    "<leader>tgv",
    function()
      require("fzf-lua").tags_grep_visual()
    end,
    desc = "Tags Grep Visual",
  },
  {
    "<leader>tlg",
    function()
      require("fzf-lua").tags_live_grep()
    end,
    desc = "Tags Live Grep",
  },
}
