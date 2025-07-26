return {
  {
    "<leader>gts",
    function()
      require("fzf-lua").git_status()
    end,
    desc = "Git Status",
  },
  {
    "<leader>gtf",
    function()
      require("fzf-lua").git_files()
    end,
    desc = "Git ls-files",
  },
  {
    "<leader>gtc",
    function()
      require("fzf-lua").git_commits()
    end,
    desc = "Git Commits",
  },
  {
    "<leader>gtbh",
    function()
      require("fzf-lua").git_branches()
    end,
    desc = "Git Branches",
  },
}
